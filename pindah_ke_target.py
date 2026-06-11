import json
import os
import subprocess
import time

TARGET_OWNER = "radenelsa7-bot"
TARGET_REPO = "radenelsa7-bot/PM_UAS_rekayasa_Sistem_Informasi"
TARGET_PROJECT_NUMBER = "1"
INPUT_FILE = "backup_lengkap.json"

MAP_TIM = {
    "PM": "radenelsa7-bot",
    "BE1": "NabilahAsana",
    "BE2": "Fajar1180",
    "BE3": "Fatinasy7",
    "FE1": "tetepsafarudin",
    "FE2": "faznalaisal44",
    "FE3": "nabilramadhan05",
    "QA": "aldyrmdny-lab"
}

if not os.path.exists(INPUT_FILE):
    print(f"✗ Gagal: File {INPUT_FILE} tidak ditemukan!")
    exit(1)

with open(INPUT_FILE, "r", encoding="utf-8") as f:
    data = json.load(f)

print(f"🚀 Memulai replikasi data ke {TARGET_REPO}...")

# 1. BUAT MILESTONES
print("\n[1/4] Sinkronisasi Milestones...")
for ms in data["milestones"]:
    cmd = ["gh", "api", f"repos/{TARGET_REPO}/milestones", "-m", "POST",
           "-f", f"title={ms['title']}", "-f", f"description={ms['description']}"]
    if ms["due_on"]:
        cmd.extend(["-f", f"due_on={ms['due_on']}"])
    subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

# 2. BUAT LABELS
print("[2/4] Sinkronisasi Labels...")
for lbl in data["labels"]:
    cmd = ["gh", "label", "create", lbl["name"], "--repo", TARGET_REPO, 
           "--color", lbl["color"], "--description", lbl["description"], "--force"]
    subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

# 3. BUAT ISSUES & LINK BOARD
print("\n[3/4] Memproses Pembuatan Isu & Penugasan Tim...")
for issue in data["issues"]:
    title = issue["title"]
    body = issue.get("body") or "No description."
    title_lower = title.lower()
    
    target_assignee = ""
    if "[pm]" in title_lower: target_assignee = MAP_TIM["PM"]
    elif "[backend]" in title_lower:
        if "database" in title_lower or "migration" in title_lower: target_assignee = MAP_TIM["BE2"]
        elif "auth" in title_lower: target_assignee = MAP_TIM["BE1"]
        else: target_assignee = MAP_TIM["BE3"]
    elif "[frontend]" in title_lower:
        if "setup" in title_lower or "struktur" in title_lower: target_assignee = MAP_TIM["FE1"]
        elif "home" in title_lower or "kategori" in title_lower: target_assignee = MAP_TIM["FE2"]
        else: target_assignee = MAP_TIM["FE3"]
    elif "[testing]" in title_lower: target_assignee = MAP_TIM["QA"]

    cmd_issue = ["gh", "issue", "create", "--repo", TARGET_REPO, "--title", title, "--body", body]
    for l in issue.get("labels", []): cmd_issue.extend(["--label", l["name"]])
    if issue.get("milestone"): cmd_issue.extend(["--milestone", issue["milestone"]["title"]])
    if target_assignee: cmd_issue.extend(["--assignee", target_assignee])

    res_issue = subprocess.run(cmd_issue, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    
    if res_issue.returncode == 0:
        new_issue_url = res_issue.stdout.strip()
        print(f"  ✅ Sukses: {title[:35]}... -> Assigned: @{target_assignee}")
        
        # Tempel kartu ke board
        cmd_board = ["gh", "project", "item-add", TARGET_PROJECT_NUMBER, "--owner", TARGET_OWNER, "--url", new_issue_url]
        subprocess.run(cmd_board, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        time.sleep(1) # Jeda anti-spam server
    else:
        # Jika gagal, tampilkan pesan error asli dari server GitHub
        err_msg = res_issue.stderr.strip()
        if "already exists" in err_msg.lower():
            print(f"  ⏭️  Dilewati (Isu sudah ada di repo target): {title[:35]}")
        else:
            print(f"  ❌ Gagal pada isu '{title[:25]}...'. Alasan: {err_msg}")

print("\n" + "="*50 + "\n🎉 Pemindahan selesai diproses!")

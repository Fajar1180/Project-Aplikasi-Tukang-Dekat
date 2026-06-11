import json
import subprocess

REPO_ASAL = "Fajar1180/Project-Aplikasi-Tukang-Dekat"
OUTPUT_FILE = "backup_lengkap.json"

print(f"📡 Menghubungi GitHub untuk mengunduh data dari {REPO_ASAL}...")

# 1. Ambil Milestones
print("  → Mengunduh daftar Milestones...")
ms_cmd = ["gh", "api", f"repos/{REPO_ASAL}/milestones", "--paginate"]
ms_res = subprocess.run(ms_cmd, stdout=subprocess.PIPE, text=True)
milestones = json.loads(ms_res.stdout) if ms_res.returncode == 0 else []

# 2. Ambil Labels
print("  → Mengunduh daftar Labels...")
lbl_cmd = ["gh", "api", f"repos/{REPO_ASAL}/labels", "--paginate"]
lbl_res = subprocess.run(lbl_cmd, stdout=subprocess.PIPE, text=True)
labels = json.loads(lbl_res.stdout) if lbl_res.returncode == 0 else []

# 3. Ambil Semua Isu (Limit 150 agar 74 isu Anda masuk semua)
print("  → Mengunduh seluruh Isu & Struktur Assignee...")
issue_cmd = [
    "gh", "issue", "list", "--repo", REPO_ASAL,
    "--state", "all", "--limit", "150",
    "--json", "title,body,labels,milestone,assignees"
]
issue_res = subprocess.run(issue_cmd, stdout=subprocess.PIPE, text=True)
issues = json.loads(issue_res.stdout) if issue_res.returncode == 0 else []

# 4. Satukan dan Simpan ke File JSON
payload = {
    "milestones": [{"title": m["title"], "due_on": m.get("due_on"), "description": m.get("description", "")} for m in milestones],
    "labels": [{"name": l["name"], "color": l["color"], "description": l.get("description", "")} for l in labels],
    "issues": issues
}

with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    json.dump(payload, f, indent=2, ensure_ascii=False)

print(f"\n✅ BERHASIL! {len(issues)} Isu, {len(labels)} Label, dan {len(milestones)} Milestone tersimpan di '{OUTPUT_FILE}'.")

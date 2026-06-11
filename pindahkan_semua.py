import json
import os
import subprocess

# =============================================================
# 1. KONFIGURASI TARGET REPOSITORI TEMAN
# =============================================================
TARGET_OWNER = "radenelsa7-bot"       # Username pemilik repo baru
TARGET_PROJECT_NUMBER = "1"           # Nomor Project Board teman Anda
JSON_FILE = "data_sprint.json"

# =============================================================
# 2. PETA OTOMATIS ASSIGNEE (Ubah username sebelah kanan sesuai akun teman Anda!)
# =============================================================
# Konversi otomatis dari akun lama Anda (Fajar1180) ke akun tim yang baru
ASSIGNEE_MAP = {
    "PM": "radenelsa7-bot",           # Akun untuk Project Manager
    "BE1": "NabilahAsana",            # Akun Backend 1
    "BE2": "Fajar1180",               # Akun Backend 2 (jika tetap Anda)
    "BE3": "Fatinasy7",               # Akun Backend 3
    "FE1": "tetepsafarudin",          # Akun Frontend 1
    "FE2": "faznalaisal44",           # Akun Frontend 2
    "FE3": "nabilramadhan05",         # Akun Frontend 3
    "QA": "aldyrmdny-lab"             # Akun Testing / QA
}

# =============================================================
# 3. PROSES MEMBACA DATA & SYNC
# =============================================================
if not os.path.exists(JSON_FILE):
    print(f"✗ Gagal: File {JSON_FILE} tidak ditemukan. Silakan ekspor ulang lewat gh CLI!")
    exit(1)

with open(JSON_FILE, "r", encoding="utf-8") as f:
    data = json.load(f)

items_list = data if isinstance(data, list) else data.get("items", [])
print(f"🚀 Membaca {len(items_list)} tugas dari {JSON_FILE}...")
print(f"📍 Target Board: @{TARGET_OWNER} #{TARGET_PROJECT_NUMBER}\n" + "-"*60)

success_count = 0
skipped_count = 0

for item in items_list:
    content = item.get("content", {})
    issue_url = content.get("url")
    title = item.get("title") or content.get("title", "")
    
    if not issue_url or issue_url == "null":
        continue
        
    print(f"🔄 Memproses: {title[:40]}...")

    # Deteksi otomatis role berdasarkan kata kunci di judul isu
    # Berfungsi memetakan siapa yang harus dipasang sebagai assignee baru
    assigned_user = ""
    title_lower = title.lower()
    
    if "[pm]" in title_lower:
        assigned_user = ASSIGNEE_MAP["PM"]
    elif "[backend]" in title_lower:
        # Distribusi otomatis tugas backend agar tidak menumpuk di satu orang
        if "database" in title_lower or "migration" in title_lower:
            assigned_user = ASSIGNEE_MAP["BE2"]
        elif "auth" in title_lower:
            assigned_user = ASSIGNEE_MAP["BE1"]
        else:
            assigned_user = ASSIGNEE_MAP["BE3"]
    elif "[frontend]" in title_lower:
        if "setup" in title_lower or "login" in title_lower:
            assigned_user = ASSIGNEE_MAP["FE1"]
        elif "home" in title_lower or "kategori" in title_lower:
            assigned_user = ASSIGNEE_MAP["FE2"]
        else:
            assigned_user = ASSIGNEE_MAP["FE3"]
    elif "[testing]" in title_lower:
        assigned_user = ASSIGNEE_MAP["QA"]

    # Menjalankan perintah gh CLI untuk mendaftarkan issue ke board target
    cmd = ["gh", "project", "item-add", TARGET_PROJECT_NUMBER, "--owner", TARGET_OWNER, "--url", issue_url]
    result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    
    if result.returncode == 0:
        # Jika kartu berhasil masuk ke board, otomatis set assignee barunya di GitHub
        if assigned_user:
            # Mengambil nomor issue dari tautan URL
            issue_number = issue_url.split("/")[-1]
            repo_fullname = f"{TARGET_OWNER}/PM_UAS_rekayasa_Sistem_Informasi"
            
            # Perintah menugaskan user baru ke issue tersebut
            assign_cmd = ["gh", "issue", "edit", issue_number, "--repo", repo_fullname, "--assignee", assigned_user]
            subprocess.run(assign_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            print(f"   └─ ✅ Sukses masuk board & Otomatis Assign ke: @{assigned_user}")
        else:
            print("   └─ ✅ Sukses masuk board (Tanpa Assignee)")
        success_count += 1
    else:
        print("   └─ skip (Sudah ada di dalam papan kerja)")
        skipped_count += 1

print("-" * 60)
print(f"🎉 Selesai Sinkronisasi Total!")
print(f"🔹 Tugas Baru Ditambahkan : {success_count}")
print(f"🔹 Tugas Dilewati (Aman)  : {skipped_count}")

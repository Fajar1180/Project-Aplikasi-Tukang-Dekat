import json
import subprocess

# === KONFIGURASI PROJECT BOARD TEMAN ===
TARGET_OWNER = "radenelsa7-bot"       # Username pemilik project board
TARGET_PROJECT_NUMBER = "1"           # Nomor Project Board yang ingin dibersihkan

print(f"🔍 Mengambil daftar kartu dari Project Board #{TARGET_PROJECT_NUMBER} milik @{TARGET_OWNER}...")

# 1. Ambil seluruh data item di project board dalam format JSON
cmd_list = [
    "gh", "project", "item-list", TARGET_PROJECT_NUMBER,
    "--owner", TARGET_OWNER,
    "--limit", "200",
    "--format", "json"
]

result = subprocess.run(cmd_list, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

if result.returncode != 0:
    print("✗ Gagal mengambil data project board. Pastikan nomor project dan pemiliknya sudah benar.")
    print(result.stderr)
    exit(1)

# 2. Parsing data JSON
data = json.loads(result.stdout)
items = data if isinstance(data, list) else data.get("items", [])

print(f"📊 Total ditemukan {len(items)} kartu di dalam board.")
print("⚡ Mulai menyisir dan menghapus kartu tanpa Assignee...\n" + "-"*50)

deleted_count = 0
kept_count = 0

# 3. Looping untuk mengecek assignees di setiap kartu
for item in items:
    item_id = item.get("id")
    assignees = item.get("assignees", [])
    title = item.get("title") or item.get("content", {}).get("title", "Tanpa Judul")

    # Jika assignees kosong (No Assignees)
    if not assignees:
        print(f"🗑️ Menghapus: {title[:40]}... (No Assignee)")
        
        # Perintah gh CLI untuk menghapus item dari project board berdasarkan ID item
        cmd_delete = [
            "gh", "project", "item-delete", TARGET_PROJECT_NUMBER,
            "--owner", TARGET_OWNER,
            "--id", item_id
        ]
        subprocess.run(cmd_delete, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        deleted_count += 1
    else:
        # Jika ada assignee-nya, biarkan tetap di board
        kept_count += 1

print("-" * 50)
print(f"🎉 Proses Pembersihan Selesai!")
print(f"🔹 Kartu kosong berhasil dihapus : {deleted_count}")
print(f"🔹 Kartu aman (Ada Assignee)     : {kept_count}")

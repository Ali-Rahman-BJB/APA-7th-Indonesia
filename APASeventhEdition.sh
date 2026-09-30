#!/bin/bash
#
# Pemasang gaya sitasi APA 7 (Indonesia) untuk Microsoft Word di macOS.
# Taruh file ini satu folder dengan APASeventhEdition.xsl.
#
# Pemakaian:
#   bash APASeventhEdition.sh             -> pasang sekali
#   bash APASeventhEdition.sh --persist   -> pasang + otomatis pasang ulang
#                                            (setelah reboot / Word diperbarui)

set -u

# ---------- Konfigurasi ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/APASeventhEdition.xsl"

LOCAL_DIR="/Library/Application Support/APAStyleTool"
LOCAL_FILE="$LOCAL_DIR/APASeventhEdition.xsl"
APPLY_SCRIPT="$LOCAL_DIR/apply.sh"
PLIST_FILE="/Library/LaunchDaemons/com.apastyle.copy.plist"
LOG_FILE="/var/log/apastylecopy.log"

WORD_APP="/Applications/Microsoft Word.app"
WORD_INFO_PLIST="$WORD_APP/Contents/Info.plist"

# ---------- Pemeriksaan awal ----------
if [[ "$(uname)" != "Darwin" ]]; then
    echo "[GAGAL] Skrip ini hanya untuk macOS. Di Windows gunakan APASeventhEdition.bat."
    exit 1
fi

if [[ ! -f "$SOURCE_FILE" ]]; then
    echo "[GAGAL] File tidak ditemukan: $SOURCE_FILE"
    echo "Pastikan APASeventhEdition.xsl berada satu folder dengan skrip ini."
    exit 1
fi

if command -v xmllint >/dev/null 2>&1; then
    if ! xmllint --noout "$SOURCE_FILE" 2>/dev/null; then
        echo "[GAGAL] APASeventhEdition.xsl bukan XML yang valid. Instalasi dibatalkan."
        exit 1
    fi
fi

# Jalankan ulang dengan sudo bila belum root (argumen ikut diteruskan)
if [[ $EUID -ne 0 ]]; then
    echo "Membutuhkan hak administrator, meminta sudo..."
    exec sudo /bin/bash "$0" "$@"
fi

# ---------- Tentukan pengguna & lokasi tujuan ----------
USERNAME="$(stat -f "%Su" /dev/console)"
USER_HOME="$(dscl . -read "/Users/$USERNAME" NFSHomeDirectory | awk '{print $2}')"

DEST_DIR_1="$WORD_APP/Contents/Resources/Style"
DEST_DIR_2="$USER_HOME/Library/Containers/com.microsoft.Word/Data/Library/Application Support/Microsoft/Office/Style"
DEST_FILE_1="$DEST_DIR_1/APASeventhEdition.xsl"
DEST_FILE_2="$DEST_DIR_2/APASeventhEdition.xsl"

if pgrep -x "Microsoft Word" >/dev/null 2>&1; then
    echo "[INFO] Microsoft Word sedang terbuka. Tutup lalu buka lagi setelah instalasi."
fi

# ---------- Salin file ----------
echo "Memasang gaya APA 7 (Indonesia)..."

mkdir -p "$LOCAL_DIR"
install -m 644 "$SOURCE_FILE" "$LOCAL_FILE" || { echo "[GAGAL] Tidak bisa menyimpan salinan lokal."; exit 1; }

OK_COUNT=0

if [[ -d "$WORD_APP" ]]; then
    if mkdir -p "$DEST_DIR_1" && cp "$LOCAL_FILE" "$DEST_FILE_1"; then
        echo "  [OK] $DEST_FILE_1"
        OK_COUNT=$((OK_COUNT + 1))
    else
        echo "  [PERINGATAN] Gagal menyalin ke $DEST_DIR_1"
        echo "               Beri Terminal izin di: Pengaturan Sistem > Privasi & Keamanan > Manajemen Aplikasi (atau Akses Disk Penuh), lalu ulangi."
    fi
else
    echo "  [LEWAT] Microsoft Word tidak ditemukan di /Applications."
fi

if mkdir -p "$DEST_DIR_2" && cp "$LOCAL_FILE" "$DEST_FILE_2"; then
    chown -R "$USERNAME" "$USER_HOME/Library/Containers/com.microsoft.Word/Data/Library/Application Support/Microsoft/Office" 2>/dev/null
    echo "  [OK] $DEST_FILE_2"
    OK_COUNT=$((OK_COUNT + 1))
else
    echo "  [PERINGATAN] Gagal menyalin ke $DEST_DIR_2"
fi

if [[ $OK_COUNT -eq 0 ]]; then
    echo "[GAGAL] Tidak ada file yang berhasil disalin."
    exit 1
fi

echo "Penyalinan selesai. Buka ulang Word, lalu pilih: Referensi > Gaya > \"APA7 Indonesia\"."

# ---------- Opsi persisten (LaunchDaemon) ----------
if [[ "${1:-}" == "--persist" ]]; then
    echo "Menyiapkan LaunchDaemon agar file otomatis dipasang ulang..."

    # Skrip pembantu: dijalankan oleh launchd (menghindari masalah karakter khusus XML di plist)
    cat > "$APPLY_SCRIPT" <<EOF
#!/bin/bash
[ -f "$LOCAL_FILE" ] || exit 0
if [ -d "$WORD_APP" ]; then
    mkdir -p "$DEST_DIR_1" && cp "$LOCAL_FILE" "$DEST_FILE_1"
fi
mkdir -p "$DEST_DIR_2" && cp "$LOCAL_FILE" "$DEST_FILE_2" && chown "$USERNAME" "$DEST_FILE_2"
exit 0
EOF
    chown root:wheel "$APPLY_SCRIPT"
    chmod 755 "$APPLY_SCRIPT"

    cat > "$PLIST_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.apastyle.copy</string>

    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$APPLY_SCRIPT</string>
    </array>

    <!-- Jalankan saat boot -->
    <key>RunAtLoad</key>
    <true/>

    <!-- Jalankan juga saat Word diperbarui (Info.plist aplikasi berubah) -->
    <key>WatchPaths</key>
    <array>
        <string>$WORD_INFO_PLIST</string>
    </array>

    <key>StandardOutPath</key>
    <string>$LOG_FILE</string>
    <key>StandardErrorPath</key>
    <string>$LOG_FILE</string>
</dict>
</plist>
EOF
    chown root:wheel "$PLIST_FILE"
    chmod 644 "$PLIST_FILE"

    if command -v plutil >/dev/null 2>&1 && ! plutil -lint "$PLIST_FILE" >/dev/null; then
        echo "[GAGAL] File plist tidak valid, LaunchDaemon tidak dimuat."
        exit 1
    fi

    # Muat ulang daemon (bootout dulu supaya aman dijalankan berulang kali)
    launchctl bootout system "$PLIST_FILE" 2>/dev/null
    if launchctl bootstrap system "$PLIST_FILE"; then
        echo "LaunchDaemon terpasang: file akan dipasang ulang saat boot dan saat Word diperbarui."
    else
        echo "[PERINGATAN] LaunchDaemon gagal dimuat. Cek: sudo launchctl print system/com.apastyle.copy"
    fi

    echo "Untuk menghapus : sudo launchctl bootout system \"$PLIST_FILE\" && sudo rm \"$PLIST_FILE\" \"$APPLY_SCRIPT\""
    echo "Log             : tail -f $LOG_FILE"
else
    echo "Tanpa --persist: LaunchDaemon tidak dipasang."
fi
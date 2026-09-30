# APA 7th Edition Indonesia untuk Microsoft Word

Gaya sitasi **APA edisi ke-7 (versi Indonesia)** untuk Microsoft Word. Setelah dipasang, gaya ini muncul di Word dengan nama **"APA7 Indonesia"** pada menu *Referensi (References) > Gaya (Style)*.

Repositori ini dikelola oleh **Ali Rahman** sebagai pemilik dan *maintainer*. Repositori ini adalah *fork* dari [APA-7th-Edition](https://github.com/briankavanaugh/APA-7th-Edition) milik Brian Kavanaugh, yang kemudian disesuaikan untuk pengguna Indonesia.

## Tentang Repositori Ini

- **Pemilik & maintainer:** Ali Rahman
- **Sumber fork:** [briankavanaugh/APA-7th-Edition](https://github.com/briankavanaugh/APA-7th-Edition) (Copyright (c) 2021 Brian Kavanaugh)
- **Dasar berkas XSLT:** APA 7th Edition XSLT hasil modifikasi Mike Slagle, ditambah dua perbaikan dari komentar pada [forum Microsoft Answers ini](https://answers.microsoft.com/en-us/msoffice/forum/all/apa-7th-edition-in-ms-word/486fc70e-b7c7-40df-89bb-f8fc07169d40)
- **Perubahan di repositori ini:**
  - Gaya sitasi diberi nama **"APA7 Indonesia"**
  - Skrip pemasang (`.bat` untuk Windows dan `.sh` untuk macOS) berbahasa Indonesia
  - Skrip memasang berkas `.xsl` **lokal** yang ada di folder yang sama, bukan mengunduhnya dari internet
  - Skrip macOS memvalidasi XML sebelum memasang dan mendukung opsi `--persist`

> **Penting:** Berkas gaya ini disediakan sebagai bantuan bagi yang membutuhkan opsi APA 7 yang lebih baik daripada bawaan Microsoft. Templat XSLT aslinya **bukan** buatan saya. Bila ada masalah, silakan perbaiki (bila memungkinkan; ada batasan pada apa yang bisa dilakukan XSLT di Word) lalu kirim *pull request*.

## Cara Penggunaan

### Windows

#### Metode manual

1. Tutup Word.
2. Salin berkas `APASeventhEdition.xsl` ke folder:
   `C:\Users\<nama_pengguna>\AppData\Roaming\Microsoft\Bibliography\Style`
3. Buka kembali Word, lalu pada tab **Referensi** pilih gaya **APA7 Indonesia**.

#### Metode berkas `.bat`

1. Tutup Word.
2. Letakkan `APASeventhEdition.bat` **satu folder** dengan `APASeventhEdition.xsl`, lalu klik dua kali.
3. Buka kembali Word, lalu pada tab **Referensi** pilih gaya **APA7 Indonesia**.

Catatan: berkas `.bat` menyalin `APASeventhEdition.xsl` dari folder yang sama ke `%appdata%\Microsoft\Bibliography\Style`. Tidak ada proses unduhan dari internet.

### macOS

#### Metode manual

1. Tutup Word.
2. Lewat Finder, salin `APASeventhEdition.xsl` ke **dua** lokasi:
   1. `HD/Applications/Microsoft Word.app/Contents/Resources/Style/` (klik kanan pada ikon aplikasi, lalu pilih "Show Package Contents")
   2. `HD/Users/<nama_pengguna>/Library/Containers/com.microsoft.Word/Data/Library/Application Support/Microsoft/Office/Style/`
3. Buka kembali Word, lalu pada tab **Referensi** pilih gaya **APA7 Indonesia**.

#### Metode skrip Terminal

* **Skrip ini meminta hak administrator dengan `sudo`. Jalankan hanya berkas yang Anda percaya dan pahami isinya.**

1. Tutup Word sepenuhnya.
2. Letakkan `APASeventhEdition.sh` **satu folder** dengan `APASeventhEdition.xsl`.
3. Buka Terminal (cari lewat Spotlight).
4. Masuk ke folder tersebut: `cd /path/ke/folder`
5. Jalankan skrip:
   1. `bash APASeventhEdition.sh`
   2. Masukkan kata sandi saat diminta. Layar tidak menampilkan apa pun saat Anda mengetik; tekan Enter setelah selesai.
   3. Berkas akan disalin ke kedua lokasi Word.
   4. *Opsional:* jalankan dengan opsi `--persist` agar berkas otomatis dipasang ulang saat *reboot* atau setelah Word diperbarui (mengatasi masalah Microsoft AutoUpdate yang menghapus berkas): `bash APASeventhEdition.sh --persist`

Catatan:

* Skrip menyimpan salinan lokal di `/Library/Application Support/APAStyleTool`, lalu menyalinnya ke dua folder Word.
* Bila Terminal gagal menyalin ke dalam `Microsoft Word.app`, beri izin di *Pengaturan Sistem > Privasi & Keamanan > Manajemen Aplikasi* (atau *Akses Disk Penuh*), lalu ulangi.
* Opsi `--persist` membuat LaunchDaemon yang berjalan saat *boot* dengan hak *root* dan memantau `Info.plist` Word. **Selalu baca skrip sebelum menjalankannya.**
* Untuk menghapus LaunchDaemon:
  `sudo launchctl bootout system /Library/LaunchDaemons/com.apastyle.copy.plist && sudo rm /Library/LaunchDaemons/com.apastyle.copy.plist "/Library/Application Support/APAStyleTool/apply.sh"`
* Log: `tail -f /var/log/apastylecopy.log`

## Kontribusi

Saran, laporan masalah (*issue*), dan *pull request* sangat diterima. Karena keterbatasan XSLT pada Word, tidak semua aturan APA 7 dapat diterapkan sempurna.

## Kredit

- **Brian Kavanaugh**, pembuat repositori asli (Copyright (c) 2021 Brian Kavanaugh)
- **Mike Slagle**, modifikasi APA 7th Edition XSLT
- Kontributor komentar di forum Microsoft Answers atas dua perbaikan tambahan
- **Ali Rahman**, pemilik dan *maintainer* repositori APA 7th Indonesia ini

## Lisensi

Repositori ini mengikuti lisensi dari repositori asli. Lihat berkas `LICENSE` untuk detailnya, dan hak cipta asli tetap dipertahankan atas nama Brian Kavanaugh.

## Penafian

Berkas ini disediakan hanya untuk tujuan edukasi beserta lokasi penempatannya. Bila instalasi Microsoft Office rusak akibat penggunaan berkas ini, saya tidak bertanggung jawab untuk memperbaiki masalah tersebut.
@echo off
setlocal

rem ============================================================
rem  Pemasang gaya sitasi APA 7 (Indonesia) untuk Microsoft Word
rem  Taruh file ini satu folder dengan APASeventhEdition.xsl,
rem  lalu klik dua kali.
rem ============================================================

set "SRC=%~dp0APASeventhEdition.xsl"
set "DEST_DIR=%appdata%\Microsoft\Bibliography\Style"
set "DEST=%DEST_DIR%\APASeventhEdition.xsl"

if not exist "%SRC%" (
    echo [GAGAL] File tidak ditemukan: "%SRC%"
    echo Pastikan APASeventhEdition.xsl berada satu folder dengan file .bat ini.
    pause
    exit /b 1
)

tasklist /FI "IMAGENAME eq WINWORD.EXE" 2>nul | find /I "WINWORD.EXE" >nul
if not errorlevel 1 (
    echo [INFO] Microsoft Word sedang terbuka. Tutup Word lalu buka lagi setelah instalasi.
)

if not exist "%DEST_DIR%" mkdir "%DEST_DIR%"

copy /Y "%SRC%" "%DEST%" >nul
if errorlevel 1 (
    echo [GAGAL] Tidak dapat menyalin file ke "%DEST_DIR%".
    pause
    exit /b 1
)

echo [BERHASIL] Gaya APA 7 terpasang di:
echo   %DEST%
echo.
echo Buka ulang Word, lalu pilih: References ^> Style ^> "APA7 Indonesia".
pause
endlocal
@echo off
cd /d "%~dp0"
yt-dlp.exe --list-extractors > supported_sites.txt 2>&1
echo Done. See supported_sites.txt

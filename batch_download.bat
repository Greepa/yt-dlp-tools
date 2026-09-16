@echo off
title yt-dlp - Batch Download
cd /d "%~dp0"

echo ============================================================
echo   yt-dlp Batch Downloader
echo   Reads URLs from: urls.txt (one URL per line)
echo   Already-downloaded videos are skipped automatically.
echo ============================================================
echo.

if not exist urls.txt (
    echo [ERROR] urls.txt not found.
    echo Create urls.txt with one URL per line, then run again.
    echo (See urls.example.txt for the format.)
    pause
    exit /b
)

yt-dlp.exe --config-location yt-dlp.conf -a urls.txt --download-archive archive.txt

echo.
echo ------------------------------------------------------------
echo Batch finished. Check: the "downloads" folder
echo.
pause

@echo off
title Download yt-dlp.exe
cd /d "%~dp0"

echo ============================================================
echo   Download yt-dlp.exe (the download engine)
echo ============================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0get_yt-dlp.ps1"

if errorlevel 1 (
    echo.
    echo [FAILED] See README.md for manual download.
    pause
)

@echo off
title Install ffmpeg for yt-dlp
cd /d "%~dp0"

echo ============================================================
echo   Install ffmpeg  (needed for 1080p merge, mp3, srt subs)
echo   Start downloading, please wait...
echo ============================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_ffmpeg.ps1"

if errorlevel 1 (
    echo.
    echo [FAILED] ffmpeg install failed.
    echo See 使用说明.md section 2 for manual install.
    pause
)

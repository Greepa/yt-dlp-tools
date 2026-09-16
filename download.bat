@echo off
title yt-dlp - Download Video
cd /d "%~dp0"

echo ============================================================
echo   yt-dlp Video Downloader
echo   Save to: the "downloads" folder (next to this script)
echo   (Supports YouTube, Bilibili, Twitter/X, 1000+ sites)
echo ============================================================
echo.

set VIDURL=
set /p VIDURL=Paste video URL and press Enter:

if "%VIDURL%"=="" (
    echo.
    echo [ERROR] No URL entered.
    pause
    exit /b
)

echo.
echo Downloading: %VIDURL%
echo ------------------------------------------------------------
yt-dlp.exe --config-location yt-dlp.conf %VIDURL%

echo.
echo ------------------------------------------------------------
echo Done. Check: the "downloads" folder
echo.
pause

@echo off
title yt-dlp - Subtitles Only
cd /d "%~dp0"

echo ============================================================
echo   Download subtitles only (no video)
echo   Save to: downloads\subs
echo   Great for analyzing video scripts.
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

yt-dlp.exe --config-location yt-dlp.conf --skip-download --no-write-info-json --no-write-thumbnail --write-auto-subs --write-subs --sub-langs "zh-Hans.*,zh-CN.*,zh-Hant.*,en.*" -o "downloads\subs\%(title).100s [%(id)s].%(ext)s" %VIDURL%

echo.
echo ------------------------------------------------------------
echo Done. Check: downloads\subs
echo Tip: install ffmpeg to auto-convert subtitles to .srt
echo.
pause

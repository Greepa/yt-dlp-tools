@echo off
title yt-dlp - Update
cd /d "%~dp0"

echo ============================================================
echo   Updating yt-dlp to the latest version...
echo   (Video sites change often - update when downloads break)
echo ============================================================
echo.

yt-dlp.exe -U

echo.
pause

@echo off
title One-click setup (ffmpeg + yt-dlp.exe)
cd /d "%~dp0"

echo ============================================================
echo   One-click setup
echo   1) Download ffmpeg  (ffmpeg.exe + ffprobe.exe)
echo   2) Download yt-dlp.exe
echo ============================================================
echo.

call install_ffmpeg.bat
call get_yt-dlp.bat

echo.
echo ============================================================
echo   Setup complete. You can now double-click the other scripts.
echo ============================================================
echo.
pause

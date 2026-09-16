@echo off
title Setup Bilibili Cookie
cd /d "%~dp0"

echo ============================================================
echo   Bilibili Cookie Setup
echo   (fixes HTTP 412 rate limit + unlocks 1080P high bitrate)
echo.
echo   STEP 1 - Copy your cookie first:
echo     a. Open bilibili.com in browser (make sure you are logged in)
echo     b. Press F12, switch to the Console tab
echo     c. Type this and press Enter:
echo.
echo            copy(document.cookie)
echo.
echo     d. Cookie is now on your clipboard
echo.
echo   STEP 2 - Press any key here to finish setup.
echo ============================================================
echo.
pause

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0set_cookie.ps1"

if errorlevel 1 (
    echo.
    echo [FAILED] See 使用说明.md for manual setup.
    pause
)

@echo off
title yt-dlp - Video Info
cd /d "%~dp0"

echo ============================================================
echo   yt-dlp Video Info (metadata only, no download)
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
yt-dlp.exe --config-location yt-dlp.conf --skip-download --no-write-info-json --no-write-thumbnail --print "Title      : %(title)s" --print "Uploader   : %(uploader)s" --print "Upload date: %(upload_date)s" --print "Duration   : %(duration_string)s" --print "Views      : %(view_count)s" --print "Likes      : %(like_count)s" --print "Comments   : %(comment_count)s" --print "URL        : %(webpage_url)s" %VIDURL%

echo.
echo ------------------------------------------------------------
echo Note: some sites do not expose like/comment counts.
echo.
pause

@echo off
title yt-dlp - Batch Stats to CSV
cd /d "%~dp0"

echo ============================================================
echo   Batch collect video stats -> video_stats.csv
echo   Reads URLs from: urls.txt (one URL per line)
echo   Columns: id,views,likes,comments,duration,uploader,upload_date,title
echo ============================================================
echo.

if not exist urls.txt (
    echo [ERROR] urls.txt not found.
    echo Create urls.txt with one URL per line, then run again.
    echo (See urls.example.txt for the format.)
    pause
    exit /b
)

echo id,views,likes,comments,duration_sec,uploader,upload_date,title > video_stats.csv

yt-dlp.exe --config-location yt-dlp.conf --skip-download --no-write-info-json --no-write-thumbnail --ignore-errors --print "%(id)s,%(view_count)s,%(like_count)s,%(comment_count)s,%(duration)s,%(uploader)s,%(upload_date)s,%(title)s" -a urls.txt >> video_stats.csv

echo.
echo ------------------------------------------------------------
echo Saved: video_stats.csv (in this folder)
echo Open with Excel. (Title is the LAST column on purpose,
echo because titles may contain commas.)
echo.
pause

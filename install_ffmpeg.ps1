$ErrorActionPreference = 'Continue'
$dest    = $PSScriptRoot
$conf    = Join-Path $dest 'yt-dlp.conf'
$tmpZip  = Join-Path $env:TEMP 'ffmpeg_dl.zip'
$tmpDir  = Join-Path $env:TEMP 'ffmpeg_extract'

Write-Host '============================================================' -ForegroundColor Cyan
Write-Host '  ffmpeg installer for yt-dlp' -ForegroundColor Cyan
Write-Host "  Target: $dest" -ForegroundColor Cyan
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host ''

if (Test-Path (Join-Path $dest 'ffmpeg.exe')) {
    Write-Host 'ffmpeg.exe already exists. Verifying...' -ForegroundColor Yellow
    & (Join-Path $dest 'ffmpeg.exe') -version 2>&1 | Select-Object -First 1
    Write-Host ''
    $r = Read-Host 'Reinstall anyway? (y/N)'
    if ($r -ne 'y') { Write-Host 'Skipped.'; exit 0 }
}

# Sources are ordered by measured speed from your network (2026-09-05 test).
$urls = @(
    'https://gh-proxy.com/https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip',
    'https://ghproxy.net/https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip',
    'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip'
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'

Write-Host 'Downloading ffmpeg (~80-150MB). This may take a few minutes...' -ForegroundColor Cyan
Write-Host ''

$ok = $false
foreach ($u in $urls) {
    try {
        Write-Host "  Trying: $u"
        if (Test-Path $tmpZip) { Remove-Item $tmpZip -Force }
        Invoke-WebRequest -Uri $u -OutFile $tmpZip -TimeoutSec 600 -UseBasicParsing
        if ((Test-Path $tmpZip) -and ((Get-Item $tmpZip).Length -gt 5MB)) {
            $mb = [math]::Round((Get-Item $tmpZip).Length / 1MB, 1)
            Write-Host "  Download OK ($mb MB)" -ForegroundColor Green
            $ok = $true
            break
        }
        Write-Host '  File too small, trying next source...' -ForegroundColor Yellow
    } catch {
        Write-Host "  Failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

if (-not $ok) {
    Write-Host ''
    Write-Host 'All download sources failed.' -ForegroundColor Red
    Write-Host 'Manual install: https://ffmpeg.org/download.html' -ForegroundColor Yellow
    Write-Host "Put ffmpeg.exe + ffprobe.exe into $dest\" -ForegroundColor Yellow
    Write-Host ''
    Read-Host 'Press Enter to exit'
    exit 1
}

Write-Host ''
Write-Host 'Extracting...' -ForegroundColor Cyan
if (Test-Path $tmpDir) { Remove-Item $tmpDir -Recurse -Force }
try {
    Expand-Archive -Path $tmpZip -DestinationPath $tmpDir -Force
} catch {
    Write-Host "Extract failed: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host 'Press Enter to exit'
    exit 1
}

$ff = Get-ChildItem -Path $tmpDir -Filter 'ffmpeg.exe'  -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
$fp = Get-ChildItem -Path $tmpDir -Filter 'ffprobe.exe' -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $ff) {
    Write-Host 'ffmpeg.exe not found inside the archive.' -ForegroundColor Red
    Read-Host 'Press Enter to exit'
    exit 1
}

Copy-Item $ff.FullName -Destination (Join-Path $dest 'ffmpeg.exe') -Force
if ($fp) { Copy-Item $fp.FullName -Destination (Join-Path $dest 'ffprobe.exe') -Force }
else     { Write-Host 'ffprobe.exe not found (optional, skipped).' -ForegroundColor Yellow }

Write-Host ''
Write-Host 'ffmpeg installed.' -ForegroundColor Green
& (Join-Path $dest 'ffmpeg.exe') -version 2>&1 | Select-Object -First 1

# ---- Enable --ffmpeg-location in yt-dlp.conf (GBK encoded) ----
if (Test-Path $conf) {
    $gbk  = [System.Text.Encoding]::GetEncoding(936)
    $text = [System.IO.File]::ReadAllText($conf, $gbk)
    if ($text -match '--ffmpeg-location') {
        $text = [regex]::Replace($text, '(?m)^\s*#*\s*--ffmpeg-location.*$', "--ffmpeg-location $confDir")
    } else {
        $text = $text.TrimEnd() + "`r`n--ffmpeg-location $confDir`r`n"
    }
    [System.IO.File]::WriteAllText($conf, $text, $gbk)
    Write-Host 'Updated yt-dlp.conf: --ffmpeg-location enabled.' -ForegroundColor Green
}

# cleanup
if (Test-Path $tmpZip) { Remove-Item $tmpZip -Force }
if (Test-Path $tmpDir) { Remove-Item $tmpDir -Recurse -Force }

Write-Host ''
Write-Host '============================================================' -ForegroundColor Green
Write-Host '  Done. You can now enable the ffmpeg options at the' -ForegroundColor Green
Write-Host '  bottom of yt-dlp.conf (remove the leading #).' -ForegroundColor Green
Write-Host '============================================================' -ForegroundColor Green
Write-Host ''
Read-Host 'Press Enter to exit'

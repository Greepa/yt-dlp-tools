$ErrorActionPreference = 'Continue'
$dest = $PSScriptRoot
$tmp  = Join-Path $dest 'yt-dlp.exe'

Write-Host '============================================================' -ForegroundColor Cyan
Write-Host '  yt-dlp.exe downloader' -ForegroundColor Cyan
Write-Host "  Target: $dest" -ForegroundColor Cyan
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host ''

$urls = @(
    'https://gh-proxy.com/https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe',
    'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe'
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'

$ok = $false
foreach ($u in $urls) {
    try {
        Write-Host "Trying: $u"
        if (Test-Path $tmp) { Remove-Item $tmp -Force }
        Invoke-WebRequest -Uri $u -OutFile $tmp -TimeoutSec 300 -UseBasicParsing
        if ((Test-Path $tmp) -and ((Get-Item $tmp).Length -gt 5MB)) {
            $mb = [math]::Round((Get-Item $tmp).Length / 1MB, 1)
            Write-Host "Download OK ($mb MB)" -ForegroundColor Green
            $ok = $true
            break
        }
        Write-Host 'File too small, trying next source...' -ForegroundColor Yellow
    } catch {
        Write-Host "Failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

if (-not $ok) {
    Write-Host ''
    Write-Host 'All download sources failed.' -ForegroundColor Red
    Write-Host 'Manual: https://github.com/yt-dlp/yt-dlp/releases/latest' -ForegroundColor Yellow
    Write-Host "Put yt-dlp.exe into this folder ($dest)." -ForegroundColor Yellow
    exit 1
}

Write-Host ''
Write-Host 'yt-dlp.exe is ready.' -ForegroundColor Green
& $tmp --version 2>&1 | Select-Object -First 1

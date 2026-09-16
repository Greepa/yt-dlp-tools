# ============================================================
#  Bilibili cookie setup for yt-dlp
#  Reads cookie from clipboard (or manual paste),
#  converts to Netscape format, saves to cookies.txt,
#  then enables --cookies in yt-dlp.conf
# ============================================================

param(
    [string]$CookieString = ''
)

$ErrorActionPreference = 'Continue'
$outFile = Join-Path $PSScriptRoot 'cookies.txt'
$confDir = ($PSScriptRoot -replace '\\', '/')
$conf    = Join-Path $PSScriptRoot 'yt-dlp.conf'

Write-Host '============================================================' -ForegroundColor Cyan
Write-Host '  Bilibili cookie setup for yt-dlp' -ForegroundColor Cyan
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host ''

# ---- 1. get cookie string: argument > clipboard > manual paste ----
$raw = $null
if ($CookieString -and $CookieString.Trim().Length -ge 10) {
    $raw = $CookieString
    Write-Host 'Using cookie passed as argument.' -ForegroundColor Green
} else {
    try { $raw = Get-Clipboard -Raw -ErrorAction Stop } catch { $raw = $null }
}

if (-not $raw -or $raw.Trim().Length -lt 10) {
    Write-Host 'Clipboard looks empty.' -ForegroundColor Yellow
    Write-Host 'Paste your cookie string below, then press Enter on an empty line:' -ForegroundColor Yellow
    Write-Host ''
    $lines = @()
    while ($true) {
        $l = Read-Host
        if ([string]::IsNullOrWhiteSpace($l)) { break }
        $lines += $l
    }
    $raw = ($lines -join ' ')
}

if (-not $raw -or $raw.Trim().Length -lt 10) {
    Write-Host 'No cookie content received. Aborted.' -ForegroundColor Red
    Read-Host 'Press Enter to exit'
    exit 1
}

# ---- 2. if pasted a curl command, extract the cookie header ----
if ($raw -match '(?i)\bcookie:\s*([^'']+)') {
    $raw = $Matches[1]
    Write-Host 'Detected curl command - extracted cookie header.' -ForegroundColor Green
}

# ---- 3. parse name=value pairs ----
$pairs = @{}
foreach ($part in ($raw -split ';')) {
    $p = $part.Trim()
    if ($p.Length -eq 0) { continue }
    $eq = $p.IndexOf('=')
    if ($eq -le 0) { continue }
    $name  = $p.Substring(0, $eq).Trim()
    $value = $p.Substring($eq + 1).Trim()
    if ($name -match '(?i)^(path|domain|expires|max-age|secure|httponly|samesite|priority)$') { continue }
    if ($name.Length -eq 0 -or $value.Length -eq 0) { continue }
    $pairs[$name] = $value
}

if ($pairs.Count -eq 0) {
    Write-Host 'Could not parse any cookie entry. Aborted.' -ForegroundColor Red
    Read-Host 'Press Enter to exit'
    exit 1
}

Write-Host "Parsed $($pairs.Count) cookie entries." -ForegroundColor Green

# ---- 4. write Netscape format ----
$expiry = [DateTimeOffset]::UtcNow.AddYears(2).ToUnixTimeSeconds()
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('# Netscape HTTP Cookie File')
[void]$sb.AppendLine('# Generated for yt-dlp - Bilibili')
foreach ($k in $pairs.Keys) {
    [void]$sb.AppendLine(".bilibili.com`tTRUE`t/`tFALSE`t$expiry`t$k`t$($pairs[$k])")
}
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($outFile, $sb.ToString(), $utf8NoBom)
Write-Host "Saved: $outFile" -ForegroundColor Green

# ---- 5. sanity check on key login fields ----
$keys  = @('SESSDATA','bili_jct','DedeUserID','DedeUserID__ckMd5','sid')
$found = @($keys | Where-Object { $pairs.ContainsKey($_) })
if ($found.Count -gt 0) {
    Write-Host ('Key login fields found: ' + ($found -join ', ')) -ForegroundColor Green
} else {
    Write-Host 'WARNING: SESSDATA not found. B站 may not treat this as logged in.' -ForegroundColor Yellow
    Write-Host 'Make sure you copied the cookie while logged in to bilibili.com.' -ForegroundColor Yellow
}

# ---- 6. enable --cookies in config (config file is GBK) ----
if (Test-Path $conf) {
    $gbk = [System.Text.Encoding]::GetEncoding(936)
    $t   = [System.IO.File]::ReadAllText($conf, $gbk)
    $t   = [regex]::Replace($t, '(?m)^\s*#*\s*--cookies\b.*$', "--cookies $($confDir)/cookies.txt")
    if ($t -notmatch '(?m)^--cookies\b') {
        $t = $t.TrimEnd() + "`n--cookies $($confDir)/cookies.txt`n"
    }
    [System.IO.File]::WriteAllText($conf, $t, $gbk)
    Write-Host 'Enabled --cookies in yt-dlp.conf' -ForegroundColor Green
}

Write-Host ''
Write-Host '============================================================' -ForegroundColor Green
Write-Host '  Done. Test it with:' -ForegroundColor Green
$exePath  = Join-Path $PSScriptRoot 'yt-dlp.exe'
$confPath = Join-Path $PSScriptRoot 'yt-dlp.conf'
Write-Host "  $exePath --config-location $confPath" -ForegroundColor White
Write-Host '      --simulate -F "https://www.bilibili.com/video/BV..."' -ForegroundColor White
Write-Host '============================================================' -ForegroundColor Green
Write-Host ''
Read-Host 'Press Enter to exit'

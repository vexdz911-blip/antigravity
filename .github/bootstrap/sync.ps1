# sync.ps1
# Simple sync script to update dotfiles or config
Set-StrictMode -Version Latest
$cfg = Join-Path $env:USERPROFILE '.config\antigravity'
if (-not (Test-Path $cfg)) { Write-Warning "$cfg not found"; exit 0 }

# If using a bare dotfiles repo, update it. Adjust as needed.
$dotbare = Join-Path $env:USERPROFILE '.dotfiles'
if (Test-Path $dotbare) {
    Push-Location $dotbare
    git fetch --all --prune
    git reset --hard origin/HEAD
    Pop-Location
    Write-Host "Bare dotfiles repo updated." -ForegroundColor Green
} else {
    # fallback: update antigravity config from upstream repo
    $cfgRepo = 'https://github.com/vexdz911-blip/antigravity.git'
    $tmp = Join-Path $env:TEMP 'antigravity-sync'
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $tmp
    git clone --depth 1 $cfgRepo $tmp
    Copy-Item -Path (Join-Path $tmp '.github') -Destination $cfg -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force $tmp
    Write-Host "Antigravity config refreshed from $cfgRepo" -ForegroundColor Green
}

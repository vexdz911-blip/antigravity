<#
windows-bootstrap.ps1
Bootstrap common developer tools and Antigravity config on Windows (PowerShell 7+).
Run elevated for package installs.
#>

Set-StrictMode -Version Latest

Write-Host "Starting Antigravity Windows bootstrap..."

function Install-WingetPackage($id) {
    try {
        winget install --id $id --accept-package-agreements --accept-source-agreements -e -h
    } catch {
        Write-Warning "winget install failed for $id: $_"
    }
}

# Ensure winget present
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Warning "winget not available. Please install App Installer from Microsoft Store or use Scoop."
} else {
    $packages = @('Git.Git','GitHub.cli','Microsoft.VisualStudioCode','Python.Python.3','NodeJS.Node','7zip.7zip')
    foreach ($p in $packages) { Install-WingetPackage $p }
}

# Create config dir
$cfg = Join-Path $env:USERPROFILE ".config\antigravity"
New-Item -ItemType Directory -Force -Path $cfg | Out-Null

# Download supporting scripts from this repo's main branch
$baseRaw = 'https://raw.githubusercontent.com/vexdz911-blip/antigravity/main/.github/bootstrap'
$filesToFetch = @('setup-venv.ps1','sync.ps1')
foreach ($f in $filesToFetch) {
    $dst = Join-Path $cfg $f
    $url = "$baseRaw/$f"
    try {
        Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $dst -ErrorAction Stop
        Write-Host "Fetched $f -> $dst"
    } catch {
        Write-Warning "Could not fetch $f from $url: $_"
    }
}

# Fetch antigravity-gemini.md for local reference
try {
    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/vexdz911-blip/antigravity/main/.github/antigravity-gemini.md' -OutFile (Join-Path $cfg 'antigravity-gemini.md') -UseBasicParsing -ErrorAction Stop
    Write-Host "Downloaded antigravity-gemini.md to $cfg"
} catch {
    Write-Warning "Failed to download antigravity-gemini.md: $_"
}

# Create a small launcher script in bin
$bin = Join-Path $cfg 'bin'
New-Item -ItemType Directory -Force -Path $bin | Out-Null
$launcher = @'
#!/usr/bin/env pwsh
# antigravity-run.ps1 - convenience launcher
param([string]$Action)
if ($Action -eq 'sync') { pwsh -NoProfile -File "$env:USERPROFILE\.config\antigravity\sync.ps1" }
elseif ($Action -eq 'setup') { pwsh -NoProfile -File "$env:USERPROFILE\.config\antigravity\setup-venv.ps1" }
else { Write-Host "antigravity-run: valid actions: sync, setup" }
'@
$launcherPath = Join-Path $bin 'antigravity-run.ps1'
$launcher | Out-File -FilePath $launcherPath -Encoding utf8 -Force

Write-Host "Bootstrap finished. Run 'pwsh -NoProfile -File $launcherPath setup' to create a virtualenv, or 'pwsh -NoProfile -File $launcherPath sync' to sync dotfiles."
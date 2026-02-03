# windows-bootstrap.ps1
# Bootstraps a Windows developer environment for Antigravity (PowerShell 7+)
Set-StrictMode -Version Latest

function Ensure-WingetOrScoop {
    if (Get-Command winget -ErrorAction SilentlyContinue) { return 'winget' }
    if (Get-Command scoop -ErrorAction SilentlyContinue) { return 'scoop' }
    return $null
}

$installer = Ensure-WingetOrScoop
if (-not $installer) {
    Write-Host "No winget or scoop found. Attempting to install winget via App Installer..." -ForegroundColor Yellow
    Write-Host "Please install App Installer from Microsoft Store if this fails." -ForegroundColor Yellow
}

# Package list
$pkgs = @(
    @{ id = 'Git.Git';       name = 'Git' },
    @{ id = 'Microsoft.VisualStudioCode'; name = 'VSCode' },
    @{ id = 'Python.Python.3'; name = 'Python' },
    @{ id = 'NodeJS.Node';   name = 'NodeJS' },
    @{ id = '7zip.7zip';     name = '7zip' }
)

if ($installer -eq 'winget') {
    foreach ($p in $pkgs) {
        Write-Host "Installing $($p.name) via winget..."
        winget install --id $($p.id) --accept-package-agreements --accept-source-agreements -e || Write-Warning "winget install failed for $($p.name)"
    }
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { winget install --id GitHub.cli -e }
} else {
    Write-Host "Please install the required tools manually (winget or scoop not available)." -ForegroundColor Yellow
}

# Prepare antigravity config dir
$cfg = Join-Path $env:USERPROFILE '.config\antigravity'
New-Item -ItemType Directory -Force -Path $cfg | Out-Null

# Download the antigravity-gemini.md into config dir for reference
$raw = 'https://raw.githubusercontent.com/vexdz911-blip/antigravity/main/.github/antigravity-gemini.md'
try {
    Invoke-WebRequest -Uri $raw -OutFile (Join-Path $cfg 'antigravity-gemini.md') -UseBasicParsing -ErrorAction Stop
} catch {
    Write-Warning "Failed to download antigravity-gemini.md: $_"
}

# Create helper scripts
$setup = @'
# setup.ps1 - local setup tasks
Set-StrictMode -Version Latest
# create python venv
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
'@

$setupPath = Join-Path $cfg 'setup.ps1'
$setup | Out-File -FilePath $setupPath -Encoding utf8 -Force

Write-Host "Bootstrap script complete. See $cfg. Run 'pwsh $setupPath' to create the venv and install deps." -ForegroundColor Green

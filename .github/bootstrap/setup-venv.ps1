# setup-venv.ps1
# Creates and activates a Python venv, upgrades pip, installs pinned deps from requirements.txt

Set-StrictMode -Version Latest
if (-not (Get-Command python -ErrorAction SilentlyContinue)) { Write-Error "Python is not installed or not in PATH."; exit 1 }

$venvPath = Join-Path $PSScriptRoot '.venv'
python -m venv $venvPath

# Activate and install
$activate = Join-Path $venvPath 'Scripts\Activate.ps1'
if (Test-Path $activate) {
    & $activate
    python -m pip install --upgrade pip
    if (Test-Path (Join-Path $PSScriptRoot 'requirements.txt')) {
        pip install -r (Join-Path $PSScriptRoot 'requirements.txt')
    } else {
        Write-Host "No requirements.txt found in $PSScriptRoot" -ForegroundColor Yellow
    }
} else {
    Write-Error "Activation script not found at $activate"
}

<#
setup-venv.ps1
Create/update Python virtualenv and install requirements.
#>
Set-StrictMode -Version Latest

$root = Get-Location
$venvDir = Join-Path $root '.venv'

if (-not (Test-Path "$venvDir")) {
    Write-Host "Creating virtualenv at $venvDir"
    python -m venv $venvDir
} else {
    Write-Host "Virtualenv already exists at $venvDir"
}

$activate = Join-Path $venvDir 'Scripts\Activate.ps1'
if (Test-Path $activate) {
    Write-Host "Activating virtualenv"
    & $activate
} else {
    Write-Warning "Activation script not found. Ensure Python venv creation succeeded."
}

# Upgrade pip and install requirements if present
try {
    python -m pip install --upgrade pip
    if (Test-Path 'requirements.txt') {
        pip install -r requirements.txt
    } else {
        Write-Host "No requirements.txt found in $root — skipping pip installs"
    }
} catch {
    Write-Warning "Error installing packages: $_"
}

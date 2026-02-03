<#
sync.ps1
Sync dotfiles or run chezmoi update. Intended to be run from scheduled task or manually.
#>
Set-StrictMode -Version Latest
$cfg = Join-Path $env:USERPROFILE '.config\antigravity'
Write-Host "Running antigravity sync against $cfg"

# If a dotfiles bare repo is configured, attempt to update it
$dotfilesDir = Join-Path $env:USERPROFILE '.dotfiles'
if (Test-Path $dotfilesDir) {
    try {
        Write-Host "Updating bare dotfiles repo"
        & git --git-dir=$dotfilesDir --work-tree=$env:USERPROFILE pull origin main
    } catch {
        Write-Warning "Failed to update bare dotfiles repo: $_"
    }
} elseif (Get-Command chezmoi -ErrorAction SilentlyContinue) {
    Write-Host "Running chezmoi update"
    chezmoi update
} else {
    Write-Warning "No dotfiles repo (.dotfiles) found and chezmoi not installed — nothing to sync"
}

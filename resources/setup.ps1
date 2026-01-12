#!/usr/bin/env pwsh

param(
    [string]$RepoUrlOverride = ""
)

$repoUrl = if ($RepoUrlOverride) {
    $RepoUrlOverride
} elseif ($env:REPO_URL_OVERRIDE) {
    $env:REPO_URL_OVERRIDE
} else {
    "https://github.com/state-of-th-art/setup-machine.git"
}

if (-not $repoUrl) {
    Write-Error "Set REPO_URL_OVERRIDE or pass -RepoUrlOverride to resources/setup.ps1"
    exit 1
}

$packages = @(
    "Git.Git",
    "GitHub.GitLFS"
)

foreach ($pkg in $packages) {
    winget install --id $pkg -e --source winget
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

git lfs install --skip-repo *> $null

$personalDir = Join-Path $env:USERPROFILE "personal"
$devDir = Join-Path $personalDir "setup-machine"
if (-not (Test-Path $personalDir)) {
    New-Item -ItemType Directory -Path $personalDir | Out-Null
}
if (-not (Test-Path $devDir)) {
    git clone $repoUrl $devDir
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Set-Location $devDir
$env:DEV_ENV = $devDir

.\run.ps1 core
.\run.ps1 node
.\run.ps1 rust
.\run.ps1 neovim
.\run.ps1 tmux
.\run.ps1 lazygit
.\dev-env.ps1

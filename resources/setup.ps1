#!/usr/bin/env pwsh

param(
    [string]$RepoUrlOverride = ""
)

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

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
    winget install --id $pkg -e --source winget --accept-package-agreements --accept-source-agreements
    $code = $LASTEXITCODE
    if ($code -ne 0 -and $code -ne 0x8A15002B) { exit $code }
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    $gitExe = Get-ChildItem -Path "${env:ProgramFiles}\Git\cmd\git.exe","${env:ProgramFiles(x86)}\Git\cmd\git.exe" `
        -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($gitExe) {
        $gitDir = Split-Path -Parent $gitExe.FullName
        $env:PATH = "$gitDir;$env:PATH"
    }
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git not on PATH yet. Close and reopen PowerShell, then re-run setup.ps1."
    exit 1
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

$ps = (Get-Command powershell -ErrorAction SilentlyContinue).Source
if (-not $ps) { $ps = "powershell" }

& $ps -ExecutionPolicy Bypass -File .\run.ps1 core
& $ps -ExecutionPolicy Bypass -File .\run.ps1 node
& $ps -ExecutionPolicy Bypass -File .\run.ps1 rust
& $ps -ExecutionPolicy Bypass -File .\run.ps1 neovim
& $ps -ExecutionPolicy Bypass -File .\run.ps1 tmux
& $ps -ExecutionPolicy Bypass -File .\run.ps1 lazygit
& $ps -ExecutionPolicy Bypass -File .\dev-env.ps1

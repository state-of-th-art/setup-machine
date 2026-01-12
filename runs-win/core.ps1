#!/usr/bin/env pwsh

$packages = @(
    "Git.Git",
    "GitHub.GitLFS",
    "BurntSushi.ripgrep.MSVC",
    "sharkdp.fd",
    "junegunn.fzf",
    "7zip.7zip",
    "Python.Python.3"
)

foreach ($pkg in $packages) {
    winget install --id $pkg -e --source winget
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

git lfs install --skip-repo *> $null

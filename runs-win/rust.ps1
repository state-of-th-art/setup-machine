#!/usr/bin/env pwsh

winget install --id Rustlang.Rustup -e --source winget
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

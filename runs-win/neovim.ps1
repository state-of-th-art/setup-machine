#!/usr/bin/env pwsh

winget install --id Neovim.Neovim -e --source winget
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

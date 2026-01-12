#!/usr/bin/env pwsh

winget install --id JesseDuffield.lazygit -e --source winget
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

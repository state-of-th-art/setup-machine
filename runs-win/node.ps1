#!/usr/bin/env pwsh

winget install --id OpenJS.NodeJS.LTS -e --source winget
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

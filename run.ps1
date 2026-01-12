#!/usr/bin/env pwsh

param(
    [string]$Filter = "",
    [switch]$Dry
)

if (-not $env:DEV_ENV) {
    Write-Error "env var DEV_ENV needs to be present"
    exit 1
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$runsDir = Join-Path $scriptDir "runs-win"

function Write-Log {
    param([string]$Message)
    if ($Dry) { Write-Host "[DRY_RUN]: $Message" } else { Write-Host $Message }
}

if (-not (Test-Path $runsDir)) {
    Write-Error "runs-win directory not found: $runsDir"
    exit 1
}

$scripts = Get-ChildItem -Path $runsDir -File
foreach ($script in $scripts) {
    if ($Filter -and ($script.BaseName -notmatch $Filter)) {
        Write-Log "grep `"$Filter`" filtered $($script.FullName)"
        continue
    }
    Write-Log "running: $($script.FullName)"
    if (-not $Dry) {
        & $script.FullName
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }
}

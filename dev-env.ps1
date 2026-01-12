#!/usr/bin/env pwsh

param(
    [switch]$Dry
)

if (-not $env:DEV_ENV) {
    Write-Error "env var DEV_ENV needs to be present"
    exit 1
}

function Write-Log {
    param([string]$Message)
    if ($Dry) { Write-Host "[DRY_RUN]: $Message" } else { Write-Host $Message }
}

function Update-Dir {
    param(
        [string]$Source,
        [string]$Destination
    )
    Write-Log "sync $Source -> $Destination"
    if (-not (Test-Path $Source)) { return }
    $dirs = Get-ChildItem -Path $Source -Directory
    foreach ($dir in $dirs) {
        $target = Join-Path $Destination $dir.Name
        Write-Log "  rm -rf $target"
        if (-not $Dry -and (Test-Path $target)) {
            Remove-Item -Path $target -Recurse -Force
        }
        Write-Log "  cp -r $($dir.FullName) $Destination"
        if (-not $Dry) {
            Copy-Item -Path $dir.FullName -Destination $Destination -Recurse -Force
        }
    }
}

function Sync-Dir {
    param(
        [string]$Source,
        [string]$Destination
    )
    Write-Log "sync $Source -> $Destination"
    if (-not (Test-Path $Source)) { return }
    if (-not $Dry -and (Test-Path $Destination)) {
        Remove-Item -Path $Destination -Recurse -Force
    }
    if (-not $Dry) {
        $parent = Split-Path -Parent $Destination
        if ($parent) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        Copy-Item -Path $Source -Destination $Destination -Recurse -Force
    }
}

$userHome = $env:USERPROFILE
$xdgConfigHome = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { $env:LOCALAPPDATA }

Update-Dir -Source (Join-Path $env:DEV_ENV "env/.local") -Destination (Join-Path $userHome ".local")

if (-not $Dry) {
    New-Item -ItemType Directory -Path (Join-Path $userHome ".local/bin") -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $userHome ".local/scripts") -Force | Out-Null
} else {
    Write-Log "mkdir -p $userHome/.local/bin $userHome/.local/scripts"
}

Sync-Dir -Source (Join-Path $env:DEV_ENV "env/.config/lazygit") `
    -Destination (Join-Path $env:APPDATA "lazygit")

Sync-Dir -Source (Join-Path $env:DEV_ENV "env/.config/nvim") `
    -Destination (Join-Path $xdgConfigHome "nvim")

[CmdletBinding()]
param(
    [string]$SourcePath = "$PSScriptRoot\src\MyModule",
    [string]$OutputPath = "$PSScriptRoot\output"
)

$ErrorActionPreference = 'Stop'

$moduleName = Split-Path $SourcePath -Leaf
$staged     = Join-Path $OutputPath $moduleName

if (Test-Path $staged) { Remove-Item $staged -Recurse -Force }
New-Item -ItemType Directory -Path $staged -Force | Out-Null

Copy-Item -Path "$SourcePath\*" -Destination $staged -Recurse -Force

$publicFunctions = Get-ChildItem -Path "$staged\Public\*.ps1" -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty BaseName

$stagedManifest = Join-Path $staged "$moduleName.psd1"
Update-ModuleManifest -Path $stagedManifest -FunctionsToExport $publicFunctions

Test-ModuleManifest -Path $stagedManifest | Out-Null

Write-Host "Built $moduleName -> $staged" -ForegroundColor Green
Get-Item $staged

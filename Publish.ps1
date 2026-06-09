[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$ApiKey,

    [string]$StagedModulePath = "$PSScriptRoot\output\MyModule",

    [ValidateSet('PSGallery')]
    [string]$Repository = 'PSGallery'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $StagedModulePath)) {
    throw "Staged module not found at '$StagedModulePath'. Run .\Build.ps1 first."
}

$manifest = Test-ModuleManifest -Path (Join-Path $StagedModulePath 'MyModule.psd1')

if ($PSCmdlet.ShouldProcess("$($manifest.Name) $($manifest.Version)", "Publish to $Repository")) {
    Publish-Module -Path $StagedModulePath -NuGetApiKey $ApiKey -Repository $Repository
    Write-Host "Published $($manifest.Name) $($manifest.Version) to $Repository" -ForegroundColor Green
}

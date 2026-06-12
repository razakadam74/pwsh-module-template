#Requires -Version 7.0

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Za-z][A-Za-z0-9]*([._-][A-Za-z0-9]+)*$')]
    [string]$ModuleName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Author,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$GitHubUser,

    [string]$Description = "PowerShell module $ModuleName."
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root    = $PSScriptRoot
$oldName = 'MyModule'

if ($ModuleName -eq $oldName) {
    throw "Pick a name other than '$oldName' (that's the template's placeholder)."
}

$year        = (Get-Date).Year
$releaseDate = (Get-Date -Format 'yyyy-MM-dd')

$tokens = [ordered]@{
    '{{ModuleName}}'  = $ModuleName
    '{{Author}}'      = $Author
    '{{GitHubUser}}'  = $GitHubUser
    '{{Year}}'        = "$year"
    '{{ReleaseDate}}' = $releaseDate
}

$placeholderFiles = @(
    'LICENSE'
    'CHANGELOG.md'
    'CONTRIBUTING.md'
    'SECURITY.md'
    '.github/ISSUE_TEMPLATE/config.yml'
    '.github/ISSUE_TEMPLATE/bug-report.yml'
)
foreach ($rel in $placeholderFiles) {
    $path = Join-Path $root $rel
    $text = Get-Content -LiteralPath $path -Raw
    foreach ($token in $tokens.GetEnumerator()) {
        $text = $text.Replace($token.Key, $token.Value)
    }
    Set-Content -LiteralPath $path -Value $text -NoNewline -Encoding utf8
}

$codeFiles = @(
    'Build.ps1'
    'Publish.ps1'
    '.github/workflows/ci.yml'
    'tests/Meta.Tests.ps1'
    'tests/Get-Hello.Tests.ps1'
)
foreach ($rel in $codeFiles) {
    $path = Join-Path $root $rel
    $text = Get-Content -LiteralPath $path -Raw
    Set-Content -LiteralPath $path -Value $text.Replace($oldName, $ModuleName) -NoNewline -Encoding utf8
}

$srcOld = Join-Path $root "src/$oldName"
Rename-Item -LiteralPath (Join-Path $srcOld "$oldName.psd1") -NewName "$ModuleName.psd1"
Rename-Item -LiteralPath (Join-Path $srcOld "$oldName.psm1") -NewName "$ModuleName.psm1"
Rename-Item -LiteralPath $srcOld -NewName $ModuleName

$manifest = Join-Path $root "src/$ModuleName/$ModuleName.psd1"
$manifestText = Get-Content -LiteralPath $manifest -Raw
Set-Content -LiteralPath $manifest -Value $manifestText.Replace($oldName, $ModuleName) -NoNewline -Encoding utf8

Update-ModuleManifest -Path $manifest `
    -Guid (New-Guid) `
    -RootModule "$ModuleName.psm1" `
    -Author $Author `
    -Description $Description `
    -Copyright "(c) $year $Author. Released under the MIT License." `
    -LicenseUri "https://github.com/$GitHubUser/$ModuleName/blob/main/LICENSE" `
    -ProjectUri "https://github.com/$GitHubUser/$ModuleName"

$readme = @(
    "# $ModuleName"
    ''
    "> $Description"
    ''
    '## Install'
    ''
    '```powershell'
    "Install-Module $ModuleName"
    '```'
    ''
    '## Usage'
    ''
    '```powershell'
    "Import-Module $ModuleName"
    "Get-Hello -Name 'World'"
    '```'
    ''
    '## Development'
    ''
    'See [CONTRIBUTING.md](CONTRIBUTING.md).'
    ''
    '## License'
    ''
    "[MIT](LICENSE) (c) $year $Author"
) -join "`n"
Set-Content -LiteralPath (Join-Path $root 'README.md') -Value ($readme + "`n") -NoNewline -Encoding utf8

$assets = Join-Path $root 'assets'
if (Test-Path -LiteralPath $assets) { Remove-Item -LiteralPath $assets -Recurse -Force }

Test-ModuleManifest -Path $manifest | Out-Null

Write-Host "Initialized '$ModuleName'." -ForegroundColor Green
Write-Host "Try: Import-Module ./src/$ModuleName/$ModuleName.psd1 -Force; Get-Hello -Name 'World'"

Remove-Item -LiteralPath $PSCommandPath -Force

BeforeAll {
    $script:ModuleRoot = Join-Path $PSScriptRoot '..\src\MyModule'
    $script:ManifestPath = Join-Path $script:ModuleRoot 'MyModule.psd1'
    $script:ModuleName = 'MyModule'

    Get-Module $script:ModuleName | Remove-Module -Force -ErrorAction SilentlyContinue
    Import-Module $script:ManifestPath -Force
    Import-Module PSScriptAnalyzer -Force
}

AfterAll {
    Get-Module $script:ModuleName | Remove-Module -Force -ErrorAction SilentlyContinue
}

Describe 'Module manifest' {
    It 'passes Test-ModuleManifest' {
        { Test-ModuleManifest -Path $script:ManifestPath } | Should -Not -Throw
    }
}

Describe 'Module import' {
    It 'imports without error' {
        { Import-Module $script:ManifestPath -Force } | Should -Not -Throw
    }
}

Describe 'Public functions' {
    It "every public .ps1 file exports a function with the matching name" {
        $publicDir = Join-Path $script:ModuleRoot 'Public'
        $files = Get-ChildItem -Path $publicDir -Filter '*.ps1' -ErrorAction SilentlyContinue
        $files | Should -Not -BeNullOrEmpty -Because 'the template ships with at least one public function'

        foreach ($file in $files) {
            $expected = $file.BaseName
            Get-Command -Name $expected -Module $script:ModuleName -ErrorAction SilentlyContinue |
            Should -Not -BeNullOrEmpty -Because "$($file.Name) should export $expected"
        }
    }
}

Describe 'Static analysis' {
    It 'PSScriptAnalyzer reports no errors or warnings' {
        $results = Invoke-ScriptAnalyzer -Path $script:ModuleRoot -Recurse -Severity Error, Warning
        $results | Should -BeNullOrEmpty -Because ($results | Out-String)
    }
}

Describe 'Help coverage' {
    It "every exported function has a Synopsis and at least one Example" {
        $exported = (Get-Module $script:ModuleName).ExportedFunctions.Keys
        $exported | Should -Not -BeNullOrEmpty

        foreach ($name in $exported) {
            $help = Get-Help $name -Full
            $help.Synopsis           | Should -Not -BeNullOrEmpty -Because "$name needs a .SYNOPSIS"
            $help.Description       | Should -Not -BeNullOrEmpty -Because "$name needs a .DESCRIPTION"
            $help.Examples.Example  | Should -Not -BeNullOrEmpty -Because "$name needs at least one .EXAMPLE"
            $help.Examples.Example   | Should -Not -BeNullOrEmpty -Because "$name needs at least one .EXAMPLE"
        }
    }
}

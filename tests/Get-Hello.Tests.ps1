BeforeAll {
    $script:ModuleRoot = Join-Path $PSScriptRoot '..\src\MyModule'
    $script:ManifestPath = Join-Path $script:ModuleRoot 'MyModule.psd1'
    $script:ModuleName = 'MyModule'

    Get-Module $script:ModuleName | Remove-Module -Force -ErrorAction SilentlyContinue
    Import-Module $script:ManifestPath -Force
}

AfterAll {
    Get-Module $script:ModuleName | Remove-Module -Force -ErrorAction SilentlyContinue
}

Describe 'Get-Hello' {
    it 'returns an object with  a Greeting matching "Hello, $Name!"' {
        $result = Get-Hello -Name 'World'
        $result | Should -Not -BeNullOrEmpty
        $result.Greeting | Should -Be 'Hello, World!'
    }

    It 'returns a [pscustomobject]' {
        $result = Get-Hello -Name 'World'
        $result | Should -BeOfType ([pscustomobject])
    }

    it 'returns two objects when given two names' {
        $result ='Ada', 'Linus' | Get-Hello 
        $result | Should -HaveCount 2
        $result[0].Name | Should -Be 'Ada'
        $result[1].Name | Should -Be 'Linus'
        # | Should -Contain { $_.Name -eq 'Ada' } | Should -Contain { $_.Name -eq 'Linus' }
    }

    it 'throws an error if Name is missing' {
        { Get-Hello -Name '' } | Should -Throw
    }
}

function Get-Hello {
    <#
     .SYNOPSIS
         One-line summary.
     .DESCRIPTION
         Longer paragraph. What it does, when to use it.
     .PARAMETER Name
         What this parameter is for.
     .EXAMPLE
         Get-Hello -Name 'World'
         Returns a greeting object for 'World'.
     .EXAMPLE
         'Ada','Linus' | Get-Hello
         Pipeline form.
     .OUTPUTS
         PSCustomObject with Name and Greeting properties.
     #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])] 
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string[]]$Name
    )
    process {
        [PSCustomObject]@{
            Name     = $Name
            Greeting = "Hello, $Name!"
        }
    }
}
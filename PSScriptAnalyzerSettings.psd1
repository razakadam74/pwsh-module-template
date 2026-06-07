@{
    IncludeDefaultRules = $true

    Severity = @(
        'Error'
        'Warning'
    )

    ExcludeRules = @(
        # Add rule names here if a default rule produces too many false positives for this codebase.
        # Document why next to each entry.
    )
}

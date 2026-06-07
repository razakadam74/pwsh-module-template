# Contributing to {{ModuleName}}

Thanks for considering a contribution!

## Ground rules

- Keep dependencies minimal. New runtime deps need a strong justification.
- Every behaviour change ships with a Pester test.
- Be kind. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## Development setup

```powershell
git clone https://github.com/{{GitHubUser}}/{{ModuleName}}.git
cd {{ModuleName}}
Import-Module .\src\{{ModuleName}}\{{ModuleName}}.psd1 -Force
Invoke-Pester
```

Requires PowerShell 7+ for development. Tests run on PowerShell 5.1 and 7+ in CI.

## Common commands

| Command                                          | What it does                |
| ------------------------------------------------ | --------------------------- |
| `Import-Module .\src\{{ModuleName}}\{{ModuleName}}.psd1 -Force` | Load the module locally     |
| `Invoke-Pester`                                  | Run the test suite          |
| `Invoke-ScriptAnalyzer -Path .\src -Recurse`     | Run linter                  |
| `Test-ModuleManifest .\src\{{ModuleName}}\{{ModuleName}}.psd1` | Validate the manifest       |
| `.\Build.ps1`                                    | Build for publish           |

## Pull request workflow

1. Fork, branch off `main`, push to your fork.
2. Open a PR against `{{GitHubUser}}/{{ModuleName}}:main`.
3. CI runs lint, manifest validation, and tests on PowerShell 5.1 and 7+ across Linux, macOS, and Windows. All checks must pass.
4. Maintainer reviews and squash-merges.

## Pull request checklist

- [ ] Tests added or updated (when code changes)
- [ ] `Invoke-ScriptAnalyzer`, `Test-ModuleManifest`, and `Invoke-Pester` all pass locally
- [ ] No new runtime dependencies (or strong justification in PR description)
- [ ] Commit message follows [Conventional Commits](https://www.conventionalcommits.org/)
- [ ] Public cmdlets use approved verbs (`Get-Verb`) and comment-based help
- [ ] `CHANGELOG.md` updated under `[Unreleased]` for user-visible changes

## Reporting security issues

Please **do not** open a public issue. See [SECURITY.md](SECURITY.md).

## Code of conduct

Participation in this project is governed by our [Code of Conduct](CODE_OF_CONDUCT.md).

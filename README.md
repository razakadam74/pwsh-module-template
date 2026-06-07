# pwsh-module-template

> An opinionated PowerShell module template — manifest, autoloader, tests, lint, CI, and publish workflow ready to go.

[![Use this template](https://img.shields.io/badge/use%20this-template-2ea44f?logo=github)](https://github.com/razakadam74/pwsh-module-template/generate)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## What you get

- Cross-platform module skeleton (`src/MyModule/{Public,Private}`) with auto-loader
- `Test-ModuleManifest`-clean `.psd1`
- Sample cmdlet (`Get-Hello`) demonstrating the project conventions
- Pester 5 test suite (module meta + cmdlet tests)
- PSScriptAnalyzer config
- GitHub Actions CI on Windows / macOS / Linux × PowerShell 5.1 / 7+
- PR + issue templates, CODE_OF_CONDUCT, SECURITY, CHANGELOG
- Bootstrap script that personalises the template in one command

## Use it

1. Click **Use this template → Create a new repository** on GitHub, or run:

   ```powershell
   gh repo create my-org/MyModule --public --template razakadam74/pwsh-module-template --clone
   cd MyModule
   ```

2. Run the bootstrap script to replace placeholders (`{{ModuleName}}`, `{{Author}}`, `{{GitHubUser}}`, `{{Year}}`, `{{ReleaseDate}}`) and rename the module folder:

   ```powershell
   .\Bootstrap.ps1 -ModuleName 'MyModule' -Author 'Your Name' -GitHubUser 'your-handle'
   ```

3. Verify it loads:

   ```powershell
   Import-Module .\src\MyModule\MyModule.psd1 -Force
   Get-Hello -Name 'World'
   Invoke-Pester
   ```

4. Push. CI runs on the first commit.

## Conventions

- Public cmdlets live in `src/<ModuleName>/Public/`, one function per file, filename matches function name.
- Private helpers live in `src/<ModuleName>/Private/`, auto-loaded but not exported.
- Every public function uses approved verbs (`Get-Verb`), `[CmdletBinding()]`, `[OutputType()]`, and comment-based help.
- Every behaviour change ships with a Pester test.
- Conventional Commits for commit messages.

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the full development workflow.

## License

[MIT](LICENSE) © Abdul-Razak Adam

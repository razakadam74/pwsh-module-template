# Security Policy

## Supported Versions

The latest minor release on the PowerShell Gallery is supported. Older versions receive fixes only for severe vulnerabilities.

## Reporting a Vulnerability

**Please do not open public GitHub issues for security problems.**

Use [GitHub's private vulnerability reporting](https://github.com/{{GitHubUser}}/{{ModuleName}}/security/advisories/new) instead. We aim to:

- Acknowledge receipt within 72 hours
- Provide a remediation timeline within 7 days
- Credit reporters in release notes (unless anonymity is requested)

## Threat Model

`{{ModuleName}}` is a PowerShell module. It runs as your user with the privileges of the session that imports it.

In scope:

- Code execution via untrusted input passed to module cmdlets
- Path traversal via crafted file names or paths in parameters
- Arbitrary command execution via shell metacharacters in spawned processes
- Supply-chain integrity of published artifacts on the PowerShell Gallery

Out of scope:

- Any vulnerability requiring an attacker who already has session-level access to your machine
- Misuse of cmdlets by an already-privileged user

## Verifying releases

Published modules on the PowerShell Gallery are signed. You can verify with:

```powershell
Get-AuthenticodeSignature (Get-Module {{ModuleName}} -ListAvailable).Path
```

# Bridge Antigravity Patch

A transparent Windows PowerShell launcher for Google Antigravity using a **local HTTP proxy**. This is an experimental network troubleshooting utility, not a region/account unlock or a modification of Gemini services.

## Current release: v0.1 (prototype)
- Detects common Windows installation paths, or accepts an explicit executable path
- Checks whether the local HTTP proxy TCP port is reachable (not a full upstream connectivity test)
- Starts Antigravity with a Chromium proxy flag and process-scoped proxy environment variables
- No DLL injection, token interception, global proxy edits, Chrome profile patches, or persistent configuration changes
- Rejects proxy URLs containing credentials and non-loopback endpoints

## Quick start
Open PowerShell in the folder containing `bridge.ps1`. With your local HTTP proxy running:
```powershell
.\bridge.ps1 -Action status -Proxy http://127.0.0.1:10809
.\bridge.ps1 -Action launch -Proxy http://127.0.0.1:10809
```
If the executable is not found, append `-Exe 'C:\Path\To\Antigravity.exe'`.

See [USAGE.md](USAGE.md) for detailed instructions.

## Limitations
- Not tested against every Antigravity release or Windows installation
- Proxy settings may not affect every helper process or login flow
- TCP reachability does not prove the upstream proxy works
- SOCKS5, GUI, automatic installation, and account region unlock are **not implemented**
- The three referenced upstream repositories have **not** been incorporated or independently security-audited

## Security
Read scripts before running. Avoid elevated PowerShell and never commit secrets. No bypass of Windows script security settings is required to read the source. Use only a proxy you control or trust.

## License
MIT — see [LICENSE](LICENSE).

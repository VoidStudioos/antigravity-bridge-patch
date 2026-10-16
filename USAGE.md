# Bridge Antigravity Patch — Usage Guide

> **Status:** v0.1 prototype. The launcher script is **not yet uploaded to this repository**. Do not run the commands below until `bridge.ps1` is added and reviewed.

## Purpose
Launch Google Antigravity on Windows with a local HTTP proxy (for example, a proxy exposed by v2rayN). This is a connection troubleshooting tool, not a guarantee of bypassing account eligibility or regional restrictions.

## Requirements
- Windows 10/11 and PowerShell
- Google Antigravity installed
- A trusted, working local HTTP proxy
- The project launcher `bridge.ps1` (not yet available in this repository)

## Usage (after the script is published)
1. Start your proxy client and enable its **HTTP** proxy listener. Confirm the port in your client; `10809` below is only an example.
2. Download and inspect the project's `bridge.ps1` source before running it.
3. Open PowerShell in the directory containing the script.
4. Run:

```powershell
.\bridge.ps1 -Action launch -Proxy http://127.0.0.1:10809
```

5. Check whether Antigravity starts and can connect. If it fails, verify the proxy port, proxy protocol, and the app installation path.

## Troubleshooting
- **Connection refused:** proxy client is stopped or the HTTP listener port is incorrect.
- **Timeout:** check the upstream proxy and firewall rules.
- **App not found:** verify Antigravity is installed; launcher auto-detection may need adjustment.
- **Login still fails:** a network proxy does not override server-side account restrictions.
- **SOCKS5 only:** configure an HTTP listener first; do not assume the current prototype supports SOCKS5 directly.

## Security
- Review scripts before execution. Do not run untrusted DLLs or scripts as administrator.
- Never commit account cookies, tokens, credentials, or proxy subscription secrets.
- Prefer a local loopback listener (`127.0.0.1`) over an externally exposed proxy.
- This guide does not recommend disabling antivirus or PowerShell security controls.

## Project status
The repository currently contains documentation only. Publishing and testing the launcher, adding a rollback mechanism, and validating behavior on Windows remain outstanding.

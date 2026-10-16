# Bridge Antigravity Patch v0.2 — Windows Guide

## Install
Download the repository as ZIP using **Code → Download ZIP**, extract it to a local directory, and inspect the PowerShell source. You need Windows 10/11, PowerShell 5.1+, and an installed Antigravity IDE. No DLL installation or administrator rights are required.

## GUI
Right-click **gui.ps1** and choose **Run with PowerShell** if your Windows policy permits local scripts. Alternatively, open PowerShell in the extracted directory and run:
\`\`\`powershell
.\gui.ps1
\`\`\`
If execution policy blocks scripts, consult your organization's policy. Do not disable system security controls solely to run this utility.

1. Start a trusted local **HTTP** proxy in your existing proxy client.
2. Click **Detect ports**. This only scans a small list of loopback TCP ports, and cannot identify whether the service speaks HTTP proxy.
3. Confirm the actual HTTP proxy address/port in your proxy client.
4. Click **Test proxy** to check local TCP reachability and IDE path detection.
5. Click **Launch IDE** to start Antigravity with process-scoped proxy settings.
6. Use **Browse** to choose the IDE executable if automatic detection fails.

## CLI
\`\`\`powershell
.\bridge.ps1 -Action status -Proxy http://127.0.0.1:10809
.\bridge.ps1 -Action launch -Proxy http://127.0.0.1:10809
.\bridge.ps1 -Action launch -Proxy http://127.0.0.1:10809 -Exe 'C:\Path\To\Antigravity.exe'
.\bridge.ps1 -Action restore
\`\`\`

## Known limitations
- A successful TCP port check does not confirm internet connectivity, authentication, or HTTP proxy protocol.
- Some helper processes and authentication flows may ignore Chromium proxy flags or environment variables.
- No SOCKS5, DLL injection, Gemini/Chrome profile modifications, region entitlement overrides, or bypass of server-side restrictions.
- **Restore** only explains that this tool made no persistent changes; it does not undo unrelated changes made by other applications.
- Untested on real Antigravity Windows installations; report failures with sanitized error output.

## Safety
Do not paste proxy passwords, cookies, access tokens, or API keys into issues. The launcher only accepts loopback HTTP proxies without embedded credentials.

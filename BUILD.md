# Windows EXE build — v0.3 preview

The EXE is a small .NET 8 Windows launcher that runs the existing PowerShell GUI. The PowerShell scripts remain visible alongside it.

## Automated build
Open GitHub Actions > Windows build and release > Run workflow. The Windows runner checks PowerShell syntax, builds a self-contained win-x64 executable, packages the executable and scripts in a ZIP, and uploads it as a workflow artifact with SHA256SUMS.txt.

Tag pushes named v* attempt to publish a GitHub Release. No tag or release is created automatically by adding this file.

## Local build
Run on Windows with .NET 8 SDK:

    dotnet publish src/BridgeAntigravityPatch/BridgeAntigravityPatch.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -o dist

The EXE is unsigned. Do not disable antivirus or other system protections. The launcher still requires Windows PowerShell and has not been integration-tested on Windows.

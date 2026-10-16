# Run on Windows PowerShell 5.1 or PowerShell 7 (Windows).
# Basic source-level and behavior smoke tests. Does not launch the IDE.
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$launcher=Join-Path $root 'bridge.ps1'
$gui=Join-Path $root 'gui.ps1'
foreach($path in @($launcher,$gui)){
  $tokens=$null;$errors=$null
  [void][System.Management.Automation.Language.Parser]::ParseFile($path,[ref]$tokens,[ref]$errors)
  if($errors.Count){throw "Syntax errors in $path : $($errors | Out-String)"}
  Write-Host "PASS: syntax $path"
}
if(-not (Select-String -Path $launcher -Pattern 'IsLoopback' -Quiet)){throw 'Missing loopback-only validation'}
Write-Host 'PASS: loopback guard present'
Write-Host 'Note: GUI integration and real proxy connectivity still require manual Windows testing.'

param(
  [ValidateSet('status','launch','restore')][string]$Action='status',
  [string]$Proxy='http://127.0.0.1:10809',
  [string]$Exe=''
)
$ErrorActionPreference='Stop'
function Find-IDE {
  if ($Exe) {
    if (-not (Test-Path -LiteralPath $Exe -PathType Leaf)) { throw "Executable not found: $Exe" }
    return (Resolve-Path -LiteralPath $Exe).Path
  }
  $candidates=@(
    (Join-Path $env:LOCALAPPDATA 'Programs\Antigravity\Antigravity.exe'),
    (Join-Path $env:LOCALAPPDATA 'Programs\Antigravity IDE\Antigravity.exe'),
    (Join-Path $env:ProgramFiles 'Antigravity\Antigravity.exe')
  )
  foreach($candidate in $candidates) { if(Test-Path -LiteralPath $candidate -PathType Leaf){return $candidate} }
  $cmd=Get-Command antigravity -ErrorAction SilentlyContinue
  if($cmd -and $cmd.Source -and (Test-Path $cmd.Source -PathType Leaf)){return $cmd.Source}
  throw 'Antigravity executable not found. Supply -Exe with its full path.'
}
if($Action -eq 'restore'){
  Write-Host 'No persistent settings were modified. Close the launched app to clear its process environment.'
  exit 0
}
$u=$null
if(-not [uri]::TryCreate($Proxy,[System.UriKind]::Absolute,[ref]$u)){throw 'Invalid proxy URL.'}
if($u.Scheme -ne 'http'){throw 'Only HTTP proxy URLs are supported in v0.1.'}
if(-not $u.IsLoopback){throw 'For safety, only loopback proxy endpoints are supported.'}
if($u.UserInfo -or $u.AbsolutePath -ne '/' -or $u.Query -or $u.Fragment){throw 'Do not include credentials, paths or query parameters in the proxy URL.'}
$target=Find-IDE
$client=New-Object System.Net.Sockets.TcpClient
try {
  $result=$client.BeginConnect($u.Host,$u.Port,$null,$null)
  $reachable=$result.AsyncWaitHandle.WaitOne(2500)
  if($reachable){try{$client.EndConnect($result)}catch{$reachable=$false}}
} catch {$reachable=$false} finally {$client.Close()}
Write-Host "IDE: $target"
Write-Host "Proxy: $($u.Scheme)://$($u.Authority)"
Write-Host "Proxy TCP reachable: $reachable"
if($Action -eq 'status'){if($reachable){exit 0}else{exit 1}}
if(-not $reachable){throw 'Proxy unreachable. Start your local HTTP proxy first.'}
$env:HTTP_PROXY=$Proxy
$env:HTTPS_PROXY=$Proxy
$env:http_proxy=$Proxy
$env:https_proxy=$Proxy
$env:NO_PROXY='localhost,127.0.0.1,::1'
$env:no_proxy=$env:NO_PROXY
Start-Process -FilePath $target -ArgumentList @("--proxy-server=$Proxy")
Write-Host 'Launched. Some subprocesses may not honor these proxy settings.'

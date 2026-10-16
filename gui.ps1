# Bridge Antigravity Patch v0.2 - Windows GUI
# Runs without administrator privileges; does not alter global proxy settings.
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$launcher=Join-Path $root 'bridge.ps1'
if(-not (Test-Path $launcher)){[System.Windows.Forms.MessageBox]::Show('bridge.ps1 is missing.');exit 1}
$form=New-Object System.Windows.Forms.Form
$form.Text='Bridge Antigravity Patch v0.2'
$form.ClientSize=New-Object System.Drawing.Size(660,430)
$form.StartPosition='CenterScreen'
$form.FormBorderStyle='FixedDialog'
$form.MaximizeBox=$false
$form.Font=New-Object System.Drawing.Font('Segoe UI',10)
function Label($text,$x,$y,$w){
  $l=New-Object System.Windows.Forms.Label
  $l.Text=$text;$l.Location=New-Object System.Drawing.Point($x,$y)
  $l.Size=New-Object System.Drawing.Size($w,26);$form.Controls.Add($l)
}
function Button($text,$x,$y,$w){
  $b=New-Object System.Windows.Forms.Button
  $b.Text=$text;$b.Location=New-Object System.Drawing.Point($x,$y)
  $b.Size=New-Object System.Drawing.Size($w,34);$form.Controls.Add($b);return $b
}
Label 'HTTP proxy (local only)' 20 18 280
$proxy=New-Object System.Windows.Forms.ComboBox
$proxy.Location=New-Object System.Drawing.Point(20,48)
$proxy.Size=New-Object System.Drawing.Size(440,30)
$proxy.DropDownStyle='DropDown'
@('http://127.0.0.1:10809','http://127.0.0.1:7890','http://127.0.0.1:2080','http://127.0.0.1:8080') | ForEach-Object {[void]$proxy.Items.Add($_)}
$proxy.SelectedIndex=0;$form.Controls.Add($proxy)
$detect=Button 'Detect ports' 475 45 160
Label 'Antigravity executable (optional; leave blank for auto detection)' 20 96 600
$exe=New-Object System.Windows.Forms.TextBox
$exe.Location=New-Object System.Drawing.Point(20,128)
$exe.Size=New-Object System.Drawing.Size(535,28)
$form.Controls.Add($exe)
$browse=Button 'Browse' 565 125 70
$test=Button 'Test proxy' 20 177 190
$launch=Button 'Launch IDE' 225 177 190
$restore=Button 'Restore info' 430 177 205
Label 'Diagnostics' 20 232 300
$log=New-Object System.Windows.Forms.TextBox
$log.Location=New-Object System.Drawing.Point(20,263)
$log.Size=New-Object System.Drawing.Size(615,147)
$log.Multiline=$true;$log.ReadOnly=$true
$log.ScrollBars='Vertical';$form.Controls.Add($log)
function Write-Log([string]$message){$log.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $message"+[Environment]::NewLine)}
function Invoke-Bridge([string]$action){
  try {
    $argsList=@('-NoProfile','-File',$launcher,'-Action',$action,'-Proxy',$proxy.Text.Trim())
    if(-not [string]::IsNullOrWhiteSpace($exe.Text)){$argsList+=@('-Exe',$exe.Text.Trim())}
    $output=& powershell.exe @argsList 2>&1 | Out-String
    Write-Log $output.Trim()
    Write-Log "Exit code: $LASTEXITCODE"
  } catch {Write-Log "ERROR: $($_.Exception.Message)"}
}
$detect.Add_Click({
  $found=@()
  foreach($port in @(10809,7890,2080,8080,1080)){
    $tcp=New-Object System.Net.Sockets.TcpClient
    try {
      $ar=$tcp.BeginConnect('127.0.0.1',$port,$null,$null)
      if($ar.AsyncWaitHandle.WaitOne(350)){
        try {$tcp.EndConnect($ar);$found+= $port} catch {}
      }
      $ar.AsyncWaitHandle.Close()
    } catch {} finally {$tcp.Close()}
  }
  if($found.Count){
    Write-Log "Open local TCP ports: $($found -join ', '). An open port is NOT proof of HTTP proxy protocol."
    $proxy.Text="http://127.0.0.1:$($found[0])"
  } else {Write-Log 'No common proxy ports responded. Set your HTTP proxy port manually.'}
})
$browse.Add_Click({
  $dlg=New-Object System.Windows.Forms.OpenFileDialog
  $dlg.Filter='Executable (*.exe)|*.exe'
  if($dlg.ShowDialog() -eq 'OK'){$exe.Text=$dlg.FileName}
  $dlg.Dispose()
})
$test.Add_Click({Invoke-Bridge 'status'})
$launch.Add_Click({Invoke-Bridge 'launch'})
$restore.Add_Click({Invoke-Bridge 'restore'})
Write-Log 'Ready. Detect ports, test your HTTP proxy, then launch.'
Write-Log 'All settings are process-scoped; no persistent changes are made.'
[void]$form.ShowDialog()

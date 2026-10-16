using System; using System.Diagnostics; using System.IO; using System.Windows.Forms;
internal static class Program {
 [STAThread] static void Main() {
 Application.EnableVisualStyles();
 string root=AppContext.BaseDirectory;
 string file=Path.Combine(root,"gui.ps1");
 if(!File.Exists(file)||!File.Exists(Path.Combine(root,"bridge.ps1"))) {MessageBox.Show("Missing PowerShell scripts next to EXE.");return;}
 var p=new ProcessStartInfo("powershell.exe"){UseShellExecute=false,WorkingDirectory=root,CreateNoWindow=true};
 p.ArgumentList.Add("-NoProfile");p.ArgumentList.Add("-File");p.ArgumentList.Add(file);
 try {using var process=Process.Start(p);process?.WaitForExit();} catch(Exception e){MessageBox.Show(e.Message);}
 }
}
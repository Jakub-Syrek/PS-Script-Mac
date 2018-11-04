cls
Function InstallApp {
param ( $computer )
$stopwatch = [system.diagnostics.stopwatch]::StartNew()
$Script:computer = $computer
$Script:destinationFolder = "\\$computer\c$\download\CherwellClient"
$Script:sourcefile = "C:\Users\Jakub\Downloads\7z1805-x64.exe"
$Script:sourcefile
Function Global:RunApp {
$computer = $Global:computer
if (Test-Connection $computer ) {
Invoke-Command -ComputerName $computer -ScriptBlock { & cmd.exe /c "c:\download\CherwellClient\7z1805-x64.exe /S" } 
$Local:destinationFolder = "\\$computer\c$\download\CherwellClient"
"File " + $Global:sourcefile + " was copied to " + $destinationFolder + "\ , executed locally and whole app was installed in " + $stopwatch.Elapsed.TotalSeconds + " seconds"
}
else
{
Write-Host "Host" $computer " not reachable"
}
}
Function Global:DeleteDir {
$computer = $Global:computer
$ErrorActionPreference = "SilentlyContinue"
Get-ChildItem -Path $destLocalFolder -Recurse | Remove-Item -Force -Recurse
Remove-Item -Path $destLocalFolder -Force 
$ErrorActionPreference = "Continue"
}
Function Script:CopyFiles {
$computer = $Script:computer #$Global:computer
$destLocalFolder = "\\" + $computer + "\c$\download\CherwellClient"
$ErrorActionPreference = "Continue"
$sourcefile1 = $Script:sourcefile
New-Item $destLocalFolder -Type Directory -Force 
Copy-Item -Path $sourcefile1 -Destination $destLocalFolder -Force 
$file = $destLocalFolder + "\7z1805-x64.exe"
"Destination file being processed now: " + $file
}
Function Global:Setproxy {
$computer = $Global:computer
Enter-PSSession -ComputerName $computer 
$Session = New-PSSession -ComputerName $computer 
$Session1 = New-PSSession -ComputerName $computer 
$GR = {
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | Select-Object *Proxy*
}
$SR = { 
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyServer" -Value "" #"proxy.example.org:8080"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "MigrateProxy" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyOverride" -Value "<local>" 
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | Select-Object *Proxy* 
}
Invoke-Command -Session $Session -ScriptBlock $GR
Invoke-Command -Session $Session1 -ScriptBlock $SR
Exit-PSSession
}
Function Global:KillInstallationalProcessIfPresent {
$computer = $Global:computer
try {
$process = "7z1805-x64"
if ((Get-Process -Name 7z1805-x64 -ComputerName $computer).ProcessName -eq $process ){
Get-Process -Name 7z1805-x64 -ComputerName $computer | stop-Process }}
catch { }
$ErrorActionPreference = "Continue"
}
Function Global:IdentifyCurrentUser { 
$computer = $Global:computer
[string]$Global:user = (Get-CimInstance –ComputerName $computer –ClassName Win32_ComputerSystem | Select-Object UserName).UserName
return $Global:user
}
Function Global:CheckIfRemotingEnabled {
$computer = $Global:computer
try 
{
Enter-PSSession -ComputerName $computer 
$Local:user = IdentifyCurrentUser 
Write-Host "Ps remoting available on host:" $computer "\" $user
Exit-PSSession
return $true
}
catch
{
Write-Host "Ps remoting not available on host:" $computer "\" $Local:user
return $false
}
}
Set-Variable -Name computer -Option AllScope
if (CheckIfRemotingEnabled) {
KillInstallationalProcessIfPresent 
DeleteDir 
CopyFiles 
Setproxy 
RunApp 
}
}
$Computers = Get-Content 'C:\Users\Jakub\Desktop\ScriptsPS\computers.txt'
$Computers | Start-Parallel -Command InstallApp -MaxThreads 500
#get-process -Name code | Select-Object -expand threads | Sort-Object ThreadState | Select-Object ID,StartTime,ThreadState,WaitReason

#$host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(160,5000) ;
$host ;
$host.UI.RawUI.BufferSize ;
$host.UI.RawUI.BufferSize.Height = 300 ;
$host.UI.RawUI.BufferSize.Width = 150 ;
$host.UI.RawUI.BufferSize ;
Add-Type System.Management.Automation.Host.Size.Width ;
$width = New-Object System.Management.Automation.Host.Size.Width; #= 200;
$width ;
Pause ;
Add-Type System::console::BufferWidth ;
[system.console]::BufferWidth = $width ;

#$host.UI.RawUI.BufferSize.GetType() ;
#= New-Object System.Management.Automation.Host.Size(160,5000) ;
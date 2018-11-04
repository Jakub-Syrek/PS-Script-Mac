ErrorActionPreference = 'SilentlyContinue'
Install-Module Start-Parallel -Force
Get-Process | Where-Object { $_.Name -eq "EXCEL" } | Select-Object -First 1 | Stop-Process
$ErrorActionPreference = 'Continue'
$stopwatch = [system.diagnostics.stopwatch]::StartNew()
$Host1 = hostname
$invocation = (Get-Variable MyInvocation).Value
$directorypath = Split-Path $invocation.MyCommand.Path
$desktopPath = [Environment]::GetFolderPath("Desktop")
$folderPath = $desktopPath + "\tmp"
$nic = gwmi -computer . -class "win32_networkadapterconfiguration" | Where-Object {$_.defaultIPGateway -ne $null}
[string]$locIP = $nic.ipaddress | select-object -first 1
[string]$EXPORT_CSV_PATH = $directorypath + "\" + "result.csv" # "C:\Users\jakub.syrek\Desktop\ScriptsPS\Work_in_progress\result.csv"
[string]$EXPORT_CSV_PATH_1 = $directorypath + "\" + "result1.csv"
[string]$IMPORT_CSV_PATH = $directorypath + "\workip.csv”
If (Test-Path $IMPORT_CSV_PATH) {
}
else
{
    #
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("No input file detected. Please check whether the file $IMPORT_CSV_PATH exists",0,"Error!",0x1)
break
}
$ErrorActionPreference = 'SilentlyContinue'
try {
(Remove-Item $EXPORT_CSV_PATH -Force )
}catch{Write-Host "File open in Excel"}
try{
Remove-Item $folderPath -Force -Recurse
}catch
{Write-Host "Directory open"}
New-Item -ItemType Directory -Force -Path $folderPath
$ErrorActionPreference = 'Continue'
$stopwatch = [system.diagnostics.stopwatch]::StartNew()
Function QuickTelnet {
param ( [IPAddress]$IP , [int]$PORT , [Int32]$ID , [string]$PROJEKT , [string]$SERVER )
$Host1= hostname
$nic = gwmi -computer . -class "win32_networkadapterconfiguration" | Where-Object {$_.defaultIPGateway -ne $null}
[string]$LOCALIP = $nic.ipaddress | select-object -first 1
$Socket = New-Object Net.Sockets.TcpClient
$ErrorActionPreference = 'SilentlyContinue'
$Socket.Connect($IP, $PORT)
$ErrorActionPreference = 'Continue'
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$folderPath = $DesktopPath + "\tmp"
[STRING]$EXPORT_CSV_PATH_2 = $folderPath + "\" + "result." + $IP +"."+ $PORT + ".csv"
if ($Socket.Connected){
$mes = "${ID}: telnet from ${LOCALIP} to ${IP} on port ${PORT} is open"
$mes
$data = @()
$row = New-Object PSObject
$row | Add-Member -MemberType NoteProperty -Name "ID" -Value $ID -TypeName Int
$row | Add-Member -MemberType NoteProperty -Name "PROJEKT" -Value $PROJEKT -TypeName String
$row | Add-Member -MemberType NoteProperty -Name "HOST_IP" -Value $LOCALIP -TypeName String
$row | Add-Member -MemberType NoteProperty -Name "TARGET_IP" -Value $IP -TypeName String
$row | Add-Member -MemberType NoteProperty -Name "TARGET_PORT" -Value $PORT
$row | Add-Member -MemberType NoteProperty -Name "SERVER" -Value $SERVER -TypeName String
$row | Add-Member -MemberType NoteProperty -Name "TELNET_RESULT" -Value "PASSED" -TypeName String
$data += $row
Start-Sleep -Seconds 10
$data | Export-Csv -Path $EXPORT_CSV_PATH_2 -Encoding ASCII -NoTypeInformation
Start-Sleep -Seconds 10
$Socket = $null
$Socket.Close()
}
else {
$mes = "${ID}: telnet from ${LOCALIP} to ${IP} on port ${PORT} is closed or filtered"
$mes
$data = @()
$row = New-Object PSObject
$row | Add-Member -MemberType NoteProperty -Name "ID" -Value $ID
$row | Add-Member -MemberType NoteProperty -Name "PROJEKT" -Value $PROJEKT -TypeName String
$row | Add-Member -MemberType NoteProperty -Name "HOST_IP" -Value $LOCALIP -TypeName String #$Host1
$row | Add-Member -MemberType NoteProperty -Name "TARGET_IP" -Value $IP -TypeName String
$row | Add-Member -MemberType NoteProperty -Name "TARGET_PORT" -Value $PORT
$row | Add-Member -MemberType NoteProperty -Name "SERVER" -Value $SERVER -TypeName String
$row | Add-Member -MemberType NoteProperty -Name "TELNET_RESULT" -Value "FAILED" -TypeName String
$data += $row
Start-Sleep -Seconds 10
$data | Export-Csv -Path $EXPORT_CSV_PATH_2 -Encoding ASCII -NoTypeInformation
Start-Sleep -Seconds 10
$Socket = $null
$Socket.Close()
}
}

import-csv $IMPORT_CSV_PATH | Start-Parallel -Command QuickTelnet -MaxThreads 500
Start-Sleep -Seconds 1
$CSV2 = Import-Csv $IMPORT_CSV_PATH
$COUNTER = $CSV2.Count
Write-Host "LocalHost =" $localIP
"Hosts scanned: " + $COUNTER
"Seconds elapsed: " + $stopwatch.Elapsed.TotalSeconds
$eff = $COUNTER / $stopwatch.Elapsed.TotalSeconds
"Efficiency: " + $eff + " telneted hosts / second"
[string]$folderPathCsv = [Environment]::GetFolderPath("Desktop") + "\tmp\*.csv"
$files = Get-ChildItem $folderPathCsv
"Files agregated: " + $files.Length
Get-Content $files | Set-Content $EXPORT_CSV_PATH -Force
WHILE (1) {
if ( $files.Length -eq $COUNTER ) {
Start-Sleep -Seconds 15
$ErrorActionPreference = 'SilentlyContinue'
$CSV3 = import-csv $EXPORT_CSV_PATH
$CSV3 | Sort-Object {[int]$_.ID} | Select-Object -Skip ($COUNTER -1) | Export-Csv -Path $EXPORT_CSV_PATH_1 -NoTypeInformation -Encoding ASCII -Force
$ErrorActionPreference = 'Continue'

"Total Seconds elapsed: " + $stopwatch.Elapsed.TotalSeconds
Function LaunchInExcel {
$xl = new-object -comobject excel.application
$xl.visible = $true
$Workbook = $xl.workbooks.OpenText("$EXPORT_CSV_PATH_1")
$Worksheets = $Workbooks.worksheets
Remove-Item $folderPath -Force -Recurse
[System.GC]::Collect()
break
}
Function EnterDataFromCSVToSql {
$SQLInstance = hostname
$SQLDatabase = "PowerShellDB"
$SQLTable = "CSVData"
$SQLTempDatabase = "tempdb1"
$SQLTempTable = "CSVDataImport"
$SQLCredentials = Get-Credential -Message "Enter your SQL username & password"
$SQLUsername = $SQLCredentials.UserName
$SQLPassword = $SQLCredentials.GetNetworkCredential().Password
$SQLModuleCheck = Get-Module -ListAvailable SqlServer
if ($SQLModuleCheck -eq $null)
{
write-host "SqlServer Module Not Found - Installing"
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name SqlServer –Scope CurrentUser -Confirm:$false -AllowClobber
}
Import-Module SqlServer
"Dropping SQL Table $PowerShellDB if exists"
$ErrorActionPreference = 'SilentlyContinue'
$SQLDrop1 = "USE master 
GO 
DROP DATABASE $SQLDatabase 
GO"
Invoke-SQLCmd -Query $SQLDrop1 -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword
$ErrorActionPreference = 'Continue'
$SQLCreateDB = "USE master; 
GO 
CREATE DATABASE $SQLDatabase
GO"
Invoke-SQLCmd -Query $SQLCreateDB -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword
$SQLCreateTable = "USE $SQLDatabase
CREATE TABLE $SQLTable (
ID int IDENTITY(1,1) PRIMARY KEY,
PROJEKT varchar(50),
HOST_IP varchar(50),
TARGET_IP varchar(50),
TARGET_PORT varchar(50),
SERVER varchar(50),
TELNET_RESULT varchar(50),
);"
Invoke-SQLCmd -Query $SQLCreateTable -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword
$SQLCreateDBtemp = "USE master; 
GO 
CREATE DATABASE $SQLTempDatabase
GO"
Invoke-SQLCmd -Query $SQLCreateDBtemp -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword
"Creating SQL Table $SQLTempTable for CSV Import" 
$SQLCreateTempTable = "USE master ; 
GO 
USE $SQLTempDatabase
GO
CREATE TABLE $SQLTempTable (
ID int IDENTITY(1,1) PRIMARY KEY,
PROJEKT varchar(50),
HOST_IP varchar(50),
TARGET_IP varchar(50),
TARGET_PORT varchar(50),
SERVER varchar(50),
TELNET_RESULT varchar(50),
);"
Invoke-SQLCmd -Query $SQLCreateTempTable -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword
"Importing CSV and processing data"
$CSVImport = Import-CSV $EXPORT_CSV_PATH_1
$CSVRowCount = $CSVImport.Count
"Inserting $CSVRowCount rows from CSV into SQL Table $SQLTempTable"
ForEach ($CSVLine in $CSVImport)
{
$CSVID = $CSVLine.ID
$CSVprojekt = $CSVLine.PROJEKT
$CSVhost_ip = $CSVLine.HOST_IP
$CSVtarget_ip = $CSVLine.TARGET_IP
$CSVtarget_port = $CSVLine.TARGET_PORT
$CSVserver = $CSVLine.SERVER
$CSVtelnet_result = $CSVLine.TELNET_RESULT
# Translating Date to SQL compatible format
#$CSVDate = "{0:yyyy-MM-dd HH:mm:ss}" -f ([DateTime]$CSVDateString)
$SQLInsertTemp = "USE master 
GO 
USE $SQLTempDatabase
GO
INSERT INTO $SQLTempTable ( PROJEKT , HOST_IP , TARGET_IP , TARGET_PORT , SERVER , TELNET_RESULT )
VALUES( '$CSVprojekt', '$CSVhost_ip', '$CSVtarget_ip' , '$CSVtarget_port' , '$CSVserver' , '$CSVtelnet_result' );"
Invoke-SQLCmd -Query $SQLInsertTemp -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword
}
"Merging SQL Table Data from $SQLTempTable to $SQLTable"
$SQLMerge = "MERGE $SQLDatabase.dbo.$SQLTable Target
USING $SQLTempDatabase.dbo.$SQLTempTable Source
ON (Target.ID = Source.ID)
WHEN MATCHED 
THEN UPDATE
SET 
Target.PROJEKT = Source.PROJEKT,
Target.HOST_IP = Source.HOST_IP,
Target.TARGET_IP = Source.TARGET_IP,
Target.TARGET_PORT = Source.TARGET_PORT,
Target.SERVER = Source.SERVER,
Target.TELNET_RESULT = Source.TELNET_RESULT
WHEN NOT MATCHED BY TARGET
THEN INSERT ( PROJEKT, HOST_IP, TARGET_IP , TARGET_PORT , SERVER , TELNET_RESULT )
VALUES ( Source.PROJEKT, Source.HOST_IP, Source.TARGET_IP , Source.TARGET_PORT , Source.SERVER , Source.TELNET_RESULT );" 
Invoke-SQLCmd -Query $SQLMerge -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword
"Total Seconds elapsed: " + $stopwatch.Elapsed.TotalSeconds
"Dropping SQL Temp Database $SQLTempDatabase as no longer needed" 
$SQLDrop = "USE master 
GO 
DROP DATABASE $SQLTempDatabase
GO" 
Invoke-SQLCmd -Query $SQLDrop -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword
}
EnterDataFromCSVToSql
LaunchInExcel
}
else
{
Start-Sleep -Seconds 3
"Data normalization finished. Seconds elapsed: " + $stopwatch.Elapsed.TotalSeconds
}
}
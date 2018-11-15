Function Encrypt ([string]$string) {
    If($String -notlike '')
    {
        ConvertTo-SecureString -String $string -AsPlainText -Force
    }
}

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent ;
Write-Host $scriptDir ;
$filebase = $PSScriptRoot ;
Write-Host 7;
pause ;
Function Set-RemedyApiConfig {
<#
.SYNOPSIS
    Set credentails and URL for use with the Remedy API. This stores the credentials as an encrypted string.
.EXAMPLE
    Set-RemedyApiConfig -APIURL https://myserver.com/api
.EXAMPLE
    Set-RemedyApiConfig -APIURL https://myserver.com/api -Path C:\Temp\Creds.xml
#>
    [cmdletbinding(SupportsShouldProcess = $true)]
    Param(
        [pscredential]$Credentials = (Get-Credential -UserName ($env:USERNAME).ToLower() -Message "Enter Remedy login details"),
        
        [Parameter(Mandatory=$true)]
        [string]$APIURL = "https://remedy.hcl.com",

        [string]$IncidentURL,
        [string]$Path =   "/usr/local/bin:RemedyApi.xml" , #"$env:USERPROFILE\$env:USERNAME-RemedyApi.xml",
        [switch]$Force   
    )

    $User = $Credentials.GetNetworkCredential().username
    $Pass = $Credentials.GetNetworkCredential().password
    $EncodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$user`:$pass"))

    $Properties = @{
        Credentials = Encrypt $EncodedCreds
        APIURL = $APIURL
        IncidentURL = $IncidentURL
    }

    $Config = New-Object -TypeName PSObject -Property $Properties 
    $Config #| Export-Clixml -Path $Path -Force
}
Set-RemedyApiConfig jakub.syrek
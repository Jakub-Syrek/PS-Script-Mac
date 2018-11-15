[System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    function ConvertTo-Encoding ([string]$From, [string]$To)
    {
        Begin{
            $encFrom = [System.Text.Encoding]::GetEncoding($from) ;
            $encTo = [System.Text.Encoding]::GetEncoding($to) ;
        }
        Process{
            $bytes = $encTo.GetBytes($_) ;
            $bytes = [System.Text.Encoding]::Convert($encFrom, $encTo, $bytes) ;
            $encTo.GetString($bytes) ;
        }
    }
    Clear-Host ;
$Title = "Bærum verk" | ConvertTo-Encoding UTF-8 Unicode ;
Write-Host "String as Unicode in UTF8 Codepage: " $Title ;
$Title = "Bærum verk" | ConvertTo-Encoding Unicode UTF-8 ;
Write-Host "String as UTF-8 in UTF8 Codepage: " $Title ;
$Title = $Title.Replace(("Bærum verk.." | ConvertTo-Encoding "UTF-8" "Unicode"), "")
Write-Host "String in UNICODE format in UTF8 Codepage: " $Title ;
[System.Console]::OutputEncoding = [System.Text.Encoding]::Unicode ;
Write-Host "String in UNICODE format in UNICODE Codepage: " $Title ;
[System.Text.Encoding]::Default.Codepage ;
Write-Host "String in UNICODE format as default: " $Title ;
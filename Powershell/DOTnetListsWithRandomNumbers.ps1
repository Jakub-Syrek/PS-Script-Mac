using namespace System.Collections.Generic.List ;
using namespace System.Collections.ArrayList ;
Clear-Host ;
$outItems = New-Object 'System.Collections.Generic.List[int16]'  ;
$outItems1 = New-Object 'System.Collections.ArrayList'  ; 
[int]$random = Get-Random -Maximum 10 -Minimum 1 ;
$outItems.Add($random) ;
$outItems1.Add($random) ;
$outItems1.Add("hi") ;
$result  = $outItems.ToArray() ;
$result | Sort-Object -Descending  ;
foreach ($file in $result)
{  
    $file ;
}
$result1 = $outItems1 | Sort-Object -Descending ;
foreach ($file in $result1)
{
    $file ;
}
$outItems.Clear() ;
$outItems1.Clear() ;
$result.Clear() ;
$result1.Clear() ;
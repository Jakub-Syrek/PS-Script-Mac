$array1 = New-Object 'object[,]' 5,5
$array1 = (1,2,3,4,5),(6,7,8,9,10),(11,12,13,14,15),(16,17,18,19,20),(21,22,23,24,25)

Measure-Command{for ([int]$i = 1 ; $i -le (($array1.Count) -2); $i++ )
{
    #CSharp way
    [string]$array2 = "" ;
    for ([int]$j = 1 ; $j -le ((($array1[$i]).Count) - 2); $j++)
    {
         $array2 +=  $array1[$i][$j] ;  
         $array2 += " " ; 
    }
    $array2 ;
    #7 8 9
    #12 13 14
    #17 18 19
}
}
[string]$array2 = "" ;
for ($i = 1 ; $i -le $array1.Count -2; $i++){
   #PS way
   $array2 +=  $array1[$i] | Select-Object -Skip 1 | Select-Object -SkipLast 1 | Out-String -Stream  ; 
   $array2 += "`n" ;
}
$array2  ;
#7 8 9
#12 13 14
#17 18 19

#PS 2 way
[string]$array2 = "" ;
foreach ($object in  $array1 | Select-Object -Skip 1 | Select-Object -SkipLast 1) 
   {    
      #$object.Item($i);
    $array2 +=   $object | Select-Object -Skip 1 | Select-Object -SkipLast 1 | Out-String -Stream  ;
    $array2 += "`n" ; 
   }
$array2  ;
#7 8 9
#12 13 14
#17 18 19




 #.Where({ $_ -ne " " })

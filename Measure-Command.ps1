$timeToCompile = Measure-Command {
[array]$list = 1 , 2 , 3 , 4 , 0 , 5 ;
foreach ($object in $list) {
    if ($object -eq 0) { break }
    else{Write-Host $object}
}
}
$timeToCompile.ToString();
#00:00:00.0020786
$timeToCompile1 = Measure-Command {
[array]$list = 1 , 2 , 3 , 4 , 0 , 5 ;
for ([int]$i = 0 ; $i -le $list.Count; $i++) {
if ($list[$i] -eq 0) { break }
    else{Write-Host $list[$i]}
}
}

$timeToCompile1.ToString();
#00:00:00.0034152
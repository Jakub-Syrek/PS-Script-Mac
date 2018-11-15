Function ConvertToBinary 
{
    param ( [int]$A , [int]$B )
    [array]$result = @() ;
    $result += [Convert]::ToString($A,2) ;
    $result += [Convert]::ToString($B,2) ;
    return $result ;
    $result.Clear() ;
}
function ConvertToHex {
    param ( [int]$A , [int]$B )
    [array]$result = @() ;
    $result += '{0:X4}' -f $A ;
    $result += '{0:X4}' -f $B ;
    return $result ;
    $result.Clear() ;
}
function EncryptBase64 {
    param ([array]$result )
    [array]$FinalResult = @() ;
    foreach ($record in $result) {
         
          $var = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($record)) ;
          $FinalResult += $var ;
        }
        $result = $FinalResult
    return $result ;
    $result.Clear() ;
    $FinalResult.Clear() ;
}
function DencryptBase64 {
    param ([array]$result )
    [array]$FinalResult = @() ;
    foreach ($record in $result) {
         
          $var = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($record));
          $FinalResult += $var ;
        }
        $result = $FinalResult
    return $result ;
    $result.Clear() ;
    $FinalResult.Clear() ;
}
function EncodeUTF8 {
    param ([array]$result )
        [array]$FinalResult = @() ;
        [string]$FinalResultString = "" ;
        foreach ($record in $result) {
            $enc = [System.Text.Encoding]::UTF8 ;
            
            $FinalResult += $enc.GetBytes($record)  ;
            $FinalResultString += $enc.GetBytes($record)

        }
            $FinalResultString
            $result = $FinalResult ;
            return $result  ;
            $result.Clear();
            $FinalResult.Clear();
        
}
function ConvertUTF8toAscii 
{
    param ([array]$result)
    foreach ($record in $result) 
    {
        $result1 += [Convert]::ToDecimal($record) ;
        #$result = $enc.GetString($result) ; #    GetBytes($result) ;
    }
        $result = $result1
        return $result  ;
        $result.Clear();
        $enc.Clear();
}       

ConvertToBinary "1918" "2018" ; #11101111110 #11111100010
EncodeUTF8 (ConvertToBinary "1918" "2018") ;
ConvertUTF8toAscii (EncodeUTF8 (ConvertToBinary "1918" "2018") ) ;
#EncryptBase64 (ConvertToBinary "1918" "2018") ; #MQAxADEAMAAxADEAMQAxADEAMQAwAA== #MQAxADEAMQAxADEAMAAwADAAMQAwAA==
#DencryptBase64 (EncryptBase64 (ConvertToBinary "1918" "2018")) #11101111110 #11111100010
#ConvertToHex "1918" "2018" ; #077E #07E2
#EncryptBase64 (ConvertToHex "1918" "2018") ; #MAA3ADcARQA= #MAA3AEUAMgA=
#DencryptBase64 (EncryptBase64 (ConvertToHex "1918" "2018")) ; #077E #07E2







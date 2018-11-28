Clear-Host ;
$stopwatch =  [system.diagnostics.stopwatch]::StartNew() ;
Function Get-Fib ([Int64]$n) 
{
    [bigint]$current = [bigint]$previous = 1;
    
    for ([Int64]$i = 0 ; $i -lt ($n+1) ; $i++ )
    {
          [bigint]$current;
          $current = $current + $previous
          $previous = $current
    }
}    
    function Get-Results {
        param ($n)
        [bigint[]]$fib = Get-Fib $n;
        [string]$lastNumber = $fib | Select-Object -Last 1 ;
        [string]$result = "";
        for ($i=0;$i -le 999;$i++) {
            if ($null -ne $lastNumber[$i] ) 
            {
            $result += $lastNumber[$i] ;
            }
        } 
        #$return = "Last " + $n + " iteration: `n" + "First 1000 digits out of " + $lastNumber.Length + "`nExecuted in:" + $stopwatch.Elapsed.ToString() + "`n" + $result ;
        [array]$return = @() ;
        $amountOfDigits = $lastNumber.Length ;
        [array]$return +=  $n , "first 1000 out of max $amountOfDigits digits"  , $stopwatch.Elapsed.ToString(),$result ;
        return $return ;
    
        $return | Out-File -FilePath /Users/jakubsyrek/Desktop/resultsFibo.txt -Append -Force ;
        
    }
    [string[]]$trend = @() ;
    $trend += (Get-Results 1) ; #00:00:00.0640166 first 1000 out of max 1 digits
    $trend += (Get-Results 10); #00:00:00.1105077 first 1000 out of max 3 digits
    $trend += (Get-Results 100) ; #00:00:00.1724725 first 1000 out of max 21 digits
    $trend += (Get-Results 1000) ; #00:00:00.2638178 first 1000 out of max 210 digits
    $trend += (Get-Results 10000) ; #00:00:00.7974904 first 1000 out of max 2090 digits
    $trend += (Get-Results 100000) ; #00:00:07.7571815 first 1000 out of max 20899 digits
    $trend += (Get-Results 200000) ; #00:00:29.0318817 first 1000 out of max 60206 digits
    $trend += (Get-Results 500000) ; #00:02:49.6743998 first 1000 out of max 150515 digits
    $trend ;
    
    
    # load the appropriate assemblies 
    #[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
    #[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")
    #Add-Type -AssemblyName System.Windows.Forms
    #Add-Type -AssemblyName System.Windows.Forms.DataVisualization


$Calculator = @"
public class Calc
{
public int Add(int a,int b)
{
return a+b;
}
public  decimal Div(decimal a,decimal b)
{   
return a/b ;
}
public int Mul(int a,int b)
{
return a*b;
}

}
"@ ;

Add-Type -TypeDefinition $Calculator  ; #PS way
$CalcInstance = [Calc]::new(); #CSharp way

$CalcInstancePS = New-Object -TypeName Calc ;
$CalcInstance.Add(20, 30) ;
$CalcInstance.Mul(5, 5) ;
$CalcInstance.Div(20, 4) ;

$CalcInstancePS.Add(20, 30) ;
$CalcInstancePS.Mul(5, 5) ;
$CalcInstancePS.Div(1.0, 4.0) ;

$CalcInstance | Get-Member ;
$CalcInstancePS.Dispose();
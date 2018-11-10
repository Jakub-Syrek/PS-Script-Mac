$Calculator= @"
public class Calc
{
public int Add(int a,int b)
{
return a+b;
}
public float Div(int a,int b)
{
return a/b;
}
public int Mul(int a,int b)
{
return a*b;
}

}
"@ ;

Add-Type -TypeDefinition $Calculator  ; 
$CalcInstance = [Calc]::new(); #CSharp way

$CalcInstancePS = New-Object -TypeName Calc ; #PS way
$CalcInstance.Add(20,30) ;
$CalcInstance.Mul(5,5) ;
$CalcInstance.Div(3,4) ;

$CalcInstancePS.Add(20,30) ;
$CalcInstancePS.Mul(5,5) ;
$CalcInstancePS.Div(3,4) ;
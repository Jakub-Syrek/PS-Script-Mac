using namespace System ;
using namespace System.Text.RegularExpressions ;
Clear-Host ; 

[array]$objectArray = @() ;
$objectArray.GetType() ; #Object[]System.Array
[string[]]$stringArray = @() ;
$stringArray.GetType() ; #String[]System.Array
$stringArray = [regex]::split("Lastname/:/FirstName/:/Address", '/:/') ;
$stringArray.GetType() ; #String[] System.Array
foreach ( $string in $stringArray ) {
    $string.GetType() ; #String System.Object
    $objectArray += $string ;
} 
$objectArray.Count ; # 3
$objectArray.GetType() ; #Object[] System.Array
foreach ( $object in $objectArray ) {
    $object.GetType() ; #String System.Object
    [regex]::replace($object,$object, { $args[0].Value.ToUpper() }) #LASTNAME FIRSTNAME ADDRESS
}



$Assem = 
$RegexUtil = @"
using  System ;
using  System.Text.RegularExpressions ;
public class RegexUtil
{
    public regex _regex = new Regex(@"/content/([a-z0-9\-]+)\.aspx$");
    public string MatchKey(string input)
    {
        Match match = _regex.Match(input.ToLower());
        if (match.Success)
        {
            return match.Groups[1].Value;
        }
        else
        {
            return null;
        }
    }
}
"@ ;


Add-Type -TypeDefinition $RegexUtil -Language CSharp ;
$string = "/content/alternate-1.aspx";
$Util = New-Object -TypeName RegexUtil ;
$Util.MatchKey($string) ;
$UtilCSharp = [RegexUtil]::new() ;
$UtilCSharp.MatchKey($string);
pause ;


$ToU = @"
public class ToUpperCSharp
{

    public string ToUpp(string a) {
        string b = a.ToUpper() ;
        return b ;
    }
}
"@ ;
Add-Type -TypeDefinition $ToU  ; 
$stringToUpperCSharpway = [ToUpperCSharp]::new(); #CSharp way
$stringToUpperCSharpway.GetType() ; #System.Object
$stringToUpperPSway = New-Object -TypeName ToUpperCSharp ; #PS way
$stringToUpperPSway.GetType() ; #System.Object
foreach ($string in $stringArray) {
    $string = $stringToUpperCSharpway.ToUpp($string) ;
    $string ;
}

foreach ($string in $stringArray) {
$string = $stringToUpperPSway.ToUpp($string) ;
$string ;
$string.GetType() ;
}
[System.GC]::GetTotalMemory(‘forcefullcollection’) | out-null
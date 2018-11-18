using System;
using  System.Collections.Generic;
using  System.Linq;

Get-ChildItem -Filter *.dll -Recurse |
    ForEach-Object {
        try {
            $_ | Add-Member NoteProperty FileVersion ($_.VersionInfo.FileVersion)
            $_ | Add-Member NoteProperty AssemblyVersion (
                [Reflection.AssemblyName]::GetAssemblyName($_.FullName).Version
            )
        } catch {}
        $_
    } |
    Select-Object Name,FileVersion,AssemblyVersion
    Get-ChildItem -Filter *.dll -Recurse | Select-Object -ExpandProperty VersionInfo

$assemblies = AppDomain.CurrentDomain.GetAssemblies ;


foreach ($assem in $assemblies)
{
    Write-Host assem.FullName ;
}

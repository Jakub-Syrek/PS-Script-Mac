using System;
using namespace System.Collections.Generic;
using namespace System.Linq;

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

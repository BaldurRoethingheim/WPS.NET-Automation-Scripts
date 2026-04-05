# Help with dialog to make a C#.NET DLL with csc.exe
# either query within Windows PowerShell (or with WinForms) and VSCode
# preferable compile AOT and Single-File-Output with self-contained (bloated)

# make dll with directory, namespace, classname
# save it, but don't open it

# unter Verwendung von dotnet command

<#

#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]
    $DLLname
)

Write-Host "DLLname: 
$DLLname";

dotnet new classlib -n $DLLname -f netstandard2.0;
Set-Location $DLLname;

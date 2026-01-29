[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]
    $text1,
    [string]
    $text2
)

if ($text1 -eq $text2) {Write-Host ("text`tequal"); return [bool]$true;}
else {Write-Host ("text`tdiffer"); return [bool]$false;}

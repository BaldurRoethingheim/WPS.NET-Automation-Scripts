# ask user shutdown time
# no value == 10 seconds to shutdown
# value == value seconds to shutdown
# TODO: string("1:12:45") == (1*60^(2) + 12*60^(1) + 45*60^(0)) seconds to shutdown

[CmdletBinding()]
param (
    [Parameter()]
    [int]
    $seconds = 0,
    [int]
    $minutes = 0,
    [int]
    $hours = 0,
    [switch]
    $keepConsole
)

function shtd {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $t = 15
    )

    shutdown.exe /s /t ($t);
    $msg1="`n`n`nHerunterfahren in $($t/60) Minuten.`n`n`n";
    
    Write-Output $msg1;
}


if (($seconds -eq 0) -and ($minutes -eq 0) -and ($hours -eq 0)) {
    $time = Read-Host "In wie viel Minuten soll heruntergefahren werden?";
    if ($time -eq "")
    {
        Write-Output "NIX";
    }
    else
    {
        shtd -t $time;
    }
}
else
{
    shtd -t ($seconds + $minutes * 60 + $hours * 3600);
}



Start-Sleep -Seconds 2;
if (!$keepConsole){Stop-Process -Name "pwsh" -Force;}

# ask user shutdown time
# no value == 10 seconds to shutdown
# value == value seconds to shutdoen
# TODO: string("1:12:45") == (1*60^(2) + 12*60^(1) + 45*60^(0)) seconds to shutdown

[CmdletBinding()]
param (
    [Parameter()]
    [int]
    $minutes = 0
)

function shtd {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $t
    )

    shutdown.exe /s /t (60*$t);
    $msg1="`n`n`nHerunterfahren in $($t) Minuten.`n`n`n"
    
    Write-Output $msg1;
    
    #[System.Windows.Forms.MessageBox]::Show("$msg1","Hinweis - Du Depp")
}


if ($minutes -eq 0) {
    $time = Read-Host "In wie viel Minuten soll heruntergefahren werden?";
    if ($time -eq "")
    {
        Write-Output "NIX";
    }
    else
    {
        shtd -t $time 
    }
}
else
{
    shtd -t $minutes
}



Start-Sleep -Seconds 3;

Stop-Process -Name "pwsh" -Force;

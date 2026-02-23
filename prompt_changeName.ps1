<# startting comments
Add this function (except the starting comments) to the windows powershell user profile via 
code $PROFILE

kinda nice for tutorials on personal pc (console)
startting comments #>


Write-Output "Function`tprompt_changeName -> {`"PS `$(Get-Location)> `"} `'sets the prompt text";
function prompt_changeName {
    [CmdletBinding()]
        param (
            [Parameter()]
            [string]
            $changeNameTo = 'IT_GUY',
            [switch]
            $RESET
        )
    if ($RESET) {
        $code = @"
param()
"PS `$(Get-Location)> "
"@
    } else {
    $USERNAME = $env:USERNAME;
    $code = @"
param()
"PS $("`$((Get-Location) -replace '$USERNAME', '$changeNameTo')")> "
"@;
    }

    Set-Content function:\global:prompt $code;    
}

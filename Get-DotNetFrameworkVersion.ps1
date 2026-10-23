function Get-DotNetFrameworkVersion {
    $regPath = "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
    $releaseKey = (Get-ItemProperty -Path $regPath -ErrorAction Stop).Release

    switch ($releaseKey) {
        { $_ -ge 533320 } { $version = "4.8.1"; break }
        { $_ -ge 528040 } { $version = "4.8"; break }
        { $_ -ge 461808 } { $version = "4.7.2"; break }
        { $_ -ge 461308 } { $version = "4.7.1"; break }
        { $_ -ge 460798 } { $version = "4.7"; break }
        { $_ -ge 394802 } { $version = "4.6.2"; break }
        { $_ -ge 394254 } { $version = "4.6.1"; break }
        { $_ -ge 393295 } { $version = "4.6"; break }
        { $_ -ge 379893 } { $version = "4.5.2"; break }
        { $_ -ge 378675 } { $version = "4.5.1"; break }
        { $_ -ge 378389 } { $version = "4.5"; break }
        default { $version = "4.0 oder Ã¤lter" }
    }

    Write-Output "Installierte .NET Framework-Version: $version (Release-Key: $releaseKey)"
}

Get-DotNetFrameworkVersion
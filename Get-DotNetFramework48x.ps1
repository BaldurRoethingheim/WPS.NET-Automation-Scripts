function Get-DotNetFramework48x {
    $key = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
    if (-not (Test-Path $key)) { return "No .NET Framework v4 Full key found." }

    $release = (Get-ItemProperty $key).Release
    $version = (Get-ItemProperty $key).Version

    [pscustomobject]@{
        Release = $release
        VersionString = $version
        Note = "Use the Release value to map to .NET Framework version (e.g., 4.8/4.8.1) per mapping tables."
    }

}

# function call
Get-DotNetFramework48x |
    Format-Table Release, VersionString, Note -AutoSize -Wrap;
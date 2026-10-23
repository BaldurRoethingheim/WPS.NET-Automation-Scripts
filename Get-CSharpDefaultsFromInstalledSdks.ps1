function Get-CSharpDefaultsFromInstalledSdks {
    if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
        return "dotnet CLI not found (no .NET SDK installed or dotnet not on PATH)."
    }

    $sdks = dotnet --list-sdks | ForEach-Object {
        # line like: 8.0.100 [C:\Program Files\dotnet\sdk]
        if ($_ -match '^(\d+)\.(\d+)\.(\d+)') {
            [pscustomobject]@{
                SdkVersion = $Matches[0]
                Major      = [int]$Matches[1]
                Minor      = [int]$Matches[2]
            }
        }
    } | Where-Object { $_ } | Sort-Object Major, Minor -Unique

    $map = @{
        11 = "C# 15"
        10 = "C# 14"
        9  = "C# 13"
        8  = "C# 12"
        7  = "C# 11"
        6  = "C# 10"
        5  = "C# 9"
        3  = "C# 8"
        2  = "C# 7.3"
    }

    $sdks | ForEach-Object {
        $csharp = $map[$_.Major]
        if (-not $csharp) { $csharp = "Unknown (check Microsoft docs for this .NET major)" }
        [pscustomobject]@{
            DotNetSdk  = $_.SdkVersion
            DotNetMajor= $_.Major
            DefaultCSharpForThatMajor = $csharp
        }
    }
}

# function call
Get-CSharpDefaultsFromInstalledSdks;
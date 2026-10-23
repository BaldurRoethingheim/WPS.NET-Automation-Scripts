
# Check .NET Framework versions from Registry
Write-Host "=== .NET Framework Versions ==="
$frameworkVersions = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
    Get-ItemProperty -Name Version -ErrorAction SilentlyContinue |
    Where-Object { $_.Version -match '^\d' } |
    Select-Object PSChildName, Version

if ($frameworkVersions) {
    $frameworkVersions | Format-Table -AutoSize
} else {
    Write-Host "No .NET Framework versions found."
}

# Check .NET Core / .NET 5+ versions using dotnet CLI
Write-Host "`n=== .NET Core / .NET 5+ Versions ==="
if (Get-Command dotnet -ErrorAction SilentlyContinue) {
    dotnet --info
} else {
    Write-Host "dotnet CLI not found. .NET Core/.NET 5+ may not be installed."
}

# Show CLR version used by current PowerShell session
Write-Host "`n=== CLR Version used by PowerShell ==="
[System.Environment]::Version

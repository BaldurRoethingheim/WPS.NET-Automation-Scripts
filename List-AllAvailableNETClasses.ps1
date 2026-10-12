[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $SlowAndSafe
)

# Load necessary assemblies
[System.Reflection.Assembly]::LoadWithPartialName("mscorlib")
[System.Reflection.Assembly]::LoadWithPartialName("System")
[System.Reflection.Assembly]::LoadWithPartialName("System.Core")

# Get all loaded assemblies
$assemblies = [AppDomain]::CurrentDomain.GetAssemblies()

#------------------------------------------------------------------------------------
# Define the string you want to fill in the editor
$content = "Pref-Fill`r`n`r`n`r`nList of all available .NET classes:`r`n`r`n`r`n"

#------------------------------------------------------------------------------------
Clear-Host;
Write-Output "Please wait a few minutes. The List is being generated."
Start-Sleep -Milliseconds 2000;
$i = 0;

# List all types (classes) in the loaded assemblies
$assemblies | ForEach-Object {
    $_.GetTypes() | Where-Object { $_.IsClass } | ForEach-Object {
        $i++;
        $content += $_.FullName + "`r`n";                                   # writes each object & NewLine into string
        Write-Output ($i.ToString() + ".:`t" + ($_.FullName).ToString());   # writes each object into each line to output
        if ($SlowAndSafe) { Start-Sleep -Milliseconds 250; }
    }
}

# Create a temporary file with the content
$tempFile = [System.IO.Path]::GetTempFileName()
Set-Content -Path $tempFile -Value $content

# Open the temporary file in Notepad
Start-Process notepad.exe $tempFile
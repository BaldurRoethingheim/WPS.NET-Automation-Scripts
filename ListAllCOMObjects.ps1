[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $ExportCSV
)



# Pfade für 64-Bit und 32-Bit COM-Registrierungen
$paths = @(
    "HKLM:\Software\Classes",
    "HKLM:\Software\WOW6432Node\Classes"
)

$results = foreach ($path in $paths) {
    if (Test-Path $path) {
        Get-ChildItem -Path $path |
            Where-Object { $_.PSChildName -match '^\w+\.\w+$' } |
            ForEach-Object {
                $progID = $_.PSChildName
                $clsidKey = Join-Path $path "$progID\CLSID"
                $clsid = if (Test-Path $clsidKey) {
                    (Get-ItemProperty -Path $clsidKey).'(default)'
                } else { $null }

                # Beschreibung
                $descKey = Join-Path $path $progID
                $description = (Get-ItemProperty -Path $descKey).'(default)'

                # Pfad zur DLL/EXE ermitteln
                $dllPath = $null
                if ($clsid) {
                    $clsidRoot = Join-Path $path "CLSID\$clsid"
                    $inprocKey = Join-Path $clsidRoot "InprocServer32"
                    $localKey  = Join-Path $clsidRoot "LocalServer32"

                    if (Test-Path $inprocKey) {
                        $dllPath = (Get-ItemProperty -Path $inprocKey).'(default)'
                    } elseif (Test-Path $localKey) {
                        $dllPath = (Get-ItemProperty -Path $localKey).'(default)'
                    }
                }

                [PSCustomObject]@{
                    ProgID      = $progID
                    CLSID       = $clsid
                    Description = $description
                    ServerPath  = $dllPath
                }
            }
    }
}

# Duplikate entfernen und sortieren
$results = $results | Sort-Object ProgID -Unique

# Ausgabe als Tabelle
Write-Host "Gefundene COM-Objekte mit CLSID, Beschreibung und Server-Pfad:" -ForegroundColor Cyan
$results | Format-Table -AutoSize

if ($ExportCSV) {
    
    $results | Export-Csv -Path "$env:USERPROFILE\Desktop\COMObjects.csv" -NoTypeInformation -Encoding UTF8;

}

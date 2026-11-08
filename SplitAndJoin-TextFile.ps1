<#
Usage:
Split into 20 MB chunks:

PowerShell
.\SplitAndJoin-TextFile.ps1 -Mode Split -Path .\a.txt

Split into 10 MB chunks:

PowerShell
.\SplitAndJoin-TextFile.ps1 -Mode Split -Path .\a.txt -MaxSizeMB 10

Reassemble:

PowerShell
.\SplitAndJoin-TextFile.ps1 -Mode Join -Path .\a_part1of2.txt
#>

param(
    [Parameter(Mandatory)]
    [ValidateSet("Split", "Join")]
    [string]$Mode,

    [Parameter(Mandatory)]
    [string]$Path,

    [int]$MaxSizeMB = 20
)

function Split-TextFile {
    param(
        [string]$FilePath,
        [int]$MaxSizeMB
    )

    $maxBytes = $MaxSizeMB * 1MB

    $fileInfo = Get-Item $FilePath
    $totalSize = $fileInfo.Length

    $partCount = [Math]::Ceiling($totalSize / $maxBytes)

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
    $extension = [System.IO.Path]::GetExtension($FilePath)
    $directory = $fileInfo.DirectoryName

    Write-Host "Input: $($fileInfo.Name)"
    Write-Host "Size: $([Math]::Round($totalSize / 1MB,2)) MB"
    Write-Host "Creating $partCount part(s)..."

    $bufferSize = 64KB
    $buffer = New-Object byte[] $bufferSize

    $inputStream = [System.IO.File]::OpenRead($FilePath)

    try {
        for ($part = 1; $part -le $partCount; $part++) {

            $digits = $partCount.ToString().Length

            $partFormatted  = $part.ToString().PadLeft($digits, '0')
            $countFormatted = $partCount.ToString().PadLeft($digits, '0')

            $partFile = Join-Path $directory "${baseName}_part${partFormatted}of${countFormatted}${extension}"

            $outputStream = [System.IO.File]::Create($partFile)

            try {
                $written = 0

                while ($written -lt $maxBytes -and $inputStream.Position -lt $inputStream.Length) {

                    $remainingPartBytes = $maxBytes - $written
                    $readSize = [Math]::Min($bufferSize, $remainingPartBytes)

                    $bytesRead = $inputStream.Read($buffer, 0, $readSize)

                    if ($bytesRead -eq 0) {
                        break
                    }

                    $outputStream.Write($buffer, 0, $bytesRead)
                    $written += $bytesRead
                }
            }
            finally {
                $outputStream.Dispose()
            }

            Write-Host "Created: $(Split-Path $partFile -Leaf)"
        }
    }
    finally {
        $inputStream.Dispose()
    }

    Write-Host "Done."
}

function Join-TextFile {
    param(
        [string]$FirstPart
    )

    $fileInfo = Get-Item $FirstPart
    $directory = $fileInfo.DirectoryName

    if ($fileInfo.BaseName -notmatch "^(.*)_part(\d+)of(\d+)$") {
        throw "Filename must match *_partXofY.txt"
    }

    $baseName = $matches[1]
    $digits = $matches[3].Length
    $partCount = [int]$matches[3]
    $extension = $fileInfo.Extension

    $outputFile = Join-Path $directory "$baseName$extension"

    Write-Host "Rebuilding: $(Split-Path $outputFile -Leaf)"

    $outputStream = [System.IO.File]::Create($outputFile)

    try {
        for ($part = 1; $part -le $partCount; $part++) {

            $digits = $partCount.ToString().Length

            $partFormatted  = $part.ToString().PadLeft($digits, '0')
            $countFormatted = $partCount.ToString().PadLeft($digits, '0')

            $partFile = Join-Path $directory "${baseName}_part${partFormatted}of${countFormatted}${extension}"


            if (-not (Test-Path $partFile)) {
                throw "Missing file: $partFile"
            }

            Write-Host "Adding: $(Split-Path $partFile -Leaf)"

            $inputStream = [System.IO.File]::OpenRead($partFile)

            try {
                $inputStream.CopyTo($outputStream)
            }
            finally {
                $inputStream.Dispose()
            }
        }
    }
    finally {
        $outputStream.Dispose()
    }

    Write-Host "Done."
}

switch ($Mode) {
    "Split" {
        Split-TextFile -FilePath $Path -MaxSizeMB $MaxSizeMB
    }
    "Join" {
        Join-TextFile -FirstPart $Path
    }
}
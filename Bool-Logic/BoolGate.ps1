    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("AND", "OR", "XOR", "XNOR", "NAND", "NOR", "NOT")]
        [string]$Gate,

        [Parameter(Mandatory = $true)]
        [bool[]]$Inputs
    )

    switch ($Gate.ToUpper()) {
        "AND" {
            $result = $true
            foreach ($inp in $Inputs) {
                $result = $result -and $inp
            }
        }
        "OR" {
            $result = $false
            foreach ($inp in $Inputs) {
                $result = $result -or $inp
            }
        }
        "XOR" {
            $result = $false
            foreach ($inp in $Inputs) {
                $result = $result -xor $inp
            }
        }
        "XNOR" {
            $result = $false
            foreach ($inp in $Inputs) {
                $result = $result -xor $inp
            }
            $result = -not $result
        }
        "NAND" {
            $result = $true
            foreach ($inp in $Inputs) {
                $result = $result -and $inp
            }
            $result = -not $result
        }
        "NOR" {
            $result = $false
            foreach ($inp in $Inputs) {
                $result = $result -or $inp
            }
            $result = -not $result
        }
        "NOT" {
            if ($Inputs.Count -ne 1) {
                throw "NOT gate requires exactly one input."
            }
            $result = -not $Inputs[0]
        }
    }

    Write-Host "$Gate result: $result"
    return [int]$result

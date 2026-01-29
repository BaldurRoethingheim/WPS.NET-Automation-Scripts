[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $KeyDown="",
    [string]
    $KeyUp="",
    [string]
    $PressKey="",
    [switch]
    $ENTER,
    [switch]
    $STRGV,
    [switch]
    $TypeAdd
)

if ($TypeAdd){
    # Add Types - but this will take some time
    $path_KS = ".\CS_Ref\KeyboardSimulator.cs";
    $result_loaded_Type = & ".\ListLoadedTypes.ps1" -search_type "KeyboardSimulator";
    if ($false -eq $result_loaded_Type) {
        Add-Type -Path $path_KS;
    }
}

if ($ENTER) {
    [KeyboardSimulator]::PressKey([byte]13);
}
elseif ($STRGV) {
    [KeyboardSimulator]::KeyDown([byte]17);
    [KeyboardSimulator]::PressKey([byte]86);
    [KeyboardSimulator]::KeyUp([byte]17);
}
elseif ($KeyDown -ne "") {
    [KeyboardSimulator]::KeyDown([byte][char]($KeyDown.ToUpper()[0]));
}
elseif ($KeyUp -ne "") {
    [KeyboardSimulator]::KeyUp([byte][char]($KeyUp.ToUpper()[0])); 
}
elseif ($PressKey -ne "") {
    [KeyboardSimulator]::PressKey([byte][char]($PressKey.ToUpper()[0])); 
}

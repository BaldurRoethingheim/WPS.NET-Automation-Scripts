# Load the required assembly
Add-Type -AssemblyName System.Windows.Forms

# Get all types in System.Windows.Forms that inherit from Control
$controlTypes = [System.Windows.Forms.Control].Assembly.GetTypes() |
    Where-Object { $_.IsPublic -and $_.IsClass -and $_.IsSubclassOf([System.Windows.Forms.Control]) } |
    Sort-Object Name

# Display available control types
Write-Host "`nList of Available System.Windows.Forms Controls:`n" -ForegroundColor Cyan
$index = 1
$controlTypes | ForEach-Object {
    Write-Host ("{0,3}. {1}" -f $index, $_.Name)
    $index++
}

# Prompt user to select a control type
$selection = Read-Host "`nEnter the number of the control you'd like to inspect (or press Enter for generic Control)"

if ([string]::IsNullOrWhiteSpace($selection)) {
    $type = [System.Windows.Forms.Control]
} else {
    $selectedIndex = [int]$selection - 1
    if ($selectedIndex -lt 0 -or $selectedIndex -ge $controlTypes.Count) {
        Write-Host "X Invalid selection. Defaulting to generic Control." -ForegroundColor Yellow
        $type = [System.Windows.Forms.Control]
    } else {
        $type = $controlTypes[$selectedIndex]
    }
}

# Create an instance of the selected control
$control = [Activator]::CreateInstance($type)

# List all events
Write-Host "`nList of Events for $($type.FullName):`n" -ForegroundColor Cyan
$control.GetType().GetEvents() | ForEach-Object {
    "{0,-30} : {1}" -f $_.Name, $_.EventHandlerType.FullName
}

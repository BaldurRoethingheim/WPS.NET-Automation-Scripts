# Prompt the user for the directory path
$directoryPath = Read-Host "Enter the directory path"

# Prompt the user for the search filter
$searchFilter = Read-Host "Enter the search filter (e.g., Pricture-C_*_A113.PNG)"

# Prompt the user for the old pattern to replace
$oldPattern = Read-Host "Enter the old pattern to replace (e.g., A113)"

# Prompt the user for the new pattern
$newPattern = Read-Host "Enter the new pattern (e.g., BD69)"

# Get all files matching the search filter
$files = Get-ChildItem -Path $directoryPath -Filter $searchFilter

# list items before the operation, to visualize the difference
Get-ChildItem -Path $directoryPath

# Loop through each file and rename it
foreach ($file in $files) {
    # Extract the part of the filename after the old pattern
    $newName = $file.Name -replace $oldPattern, $newPattern
    
    # Define the new file path
    $newFilePath = Join-Path -Path $directoryPath -ChildPath $newName
    
    # Rename the file
    Rename-Item -Path $file.FullName -NewName $newFilePath
}

Write-Host "`r`n`r`nFiles successfully renamed!`r`n`r`n"

# list items after the operation, to visualize the difference
Get-ChildItem -Path $directoryPath
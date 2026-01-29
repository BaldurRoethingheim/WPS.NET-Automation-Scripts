
Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "Virtueller Key Test"
$form.Width = 400
$form.Height = 200
$form.BackColor = [System.Drawing.Color]::Cyan
$form.KeyPreview = $true

$form.Add_KeyDown({
    param($sender, $e)
    $vkByte = [byte]$e.KeyValue
    $vkHex  = ('0x{0:X2}' -f $vkByte)  # Hex-Darstellung
    [System.Windows.Forms.MessageBox]::Show(
        "Taste: " + $e.KeyCode + "`n" +
        "VK-Code (dezimal): " + $vkByte + "`n" +
        "VK-Code (hex): " + $vkHex,
        "Information of pressed key"
    )
})

[void]$form.ShowDialog()

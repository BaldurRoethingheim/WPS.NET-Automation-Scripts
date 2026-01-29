<#
.description
IDE in WPS for WPS.NET Winforms 

#>

# Assemblies hinzufügen - Anfang
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Reflection
Add-Type -AssemblyName System.Collections
# Assemblies hinzufügen - Ende


# UTF-8 anzeigefähig-machend oder einfach mit der VSC Option "UTF-8 with BOM" (rechts unten) abspeichern
#chcp 65001
#$OutputEncoding = [System.Text.UTF8Encoding]::new($false)

#$defaultColor = [System.Drawing.Color]::LightGray  #$form.BackColor
$defaultColor = [System.Drawing.Color]::FromKnownColor([System.Drawing.KnownColor]::Control)  #$form.BackColor


#region Form - Anfang
# Formular erstellen
[System.Windows.Forms.Form]$form = New-Object System.Windows.Forms.Form
# Formular mit Werten ausstatten
$form.Text = "Test Formular"
$form.Size = New-Object System.Drawing.Size(400,300)
$form.StartPosition = "CenterScreen" # 1 # "CenterParent" # 4
$form.WindowState = "Maximized" # "Normal" # "Maximized" # "Minimized"
$form.FormBorderStyle = "Sizable" # "None" # "FixedSingle" # "Fixed3D" # "FixedDialog" # "Sizable" # "FixedToolWindow" # "SizableToolWindow"
$form.TopMost = $true
#endregion Form - Ende

#region UI-Elemente - Anfang
# button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Klick mich!"
$button.Size = New-Object System.Drawing.Size(200,40)
$button.Location = New-Object System.Drawing.Point(50,00)
$button.Name = "Button_Btn"
$button.Font = [System.Drawing.Font]::new("Consolas", 12.0)

# button2_Btn
$button2_Btn = New-Object System.Windows.Forms.Button
$button2_Btn.Text = "Nein, klick mich!"
$button2_Btn.Size = New-Object System.Drawing.Size(100,40)
$button2_Btn.Location = New-Object System.Drawing.Point(100,40)
$button2_Btn.Name = "Button2_Btn"

# Eingabe_Edt
$Eingabe_Edt = New-Object System.Windows.Forms.TextBox
$Eingabe_Edt.AutoSize = $true
$Eingabe_Edt.Size = New-Object System.Drawing.Size(300,20)
$Eingabe_Edt.Font = [System.Drawing.Font]::new("Arial", 24.0)
$Eingabe_Edt.Location = New-Object System.Drawing.Point(50,80)

#endregion UI-Elemente - Ende



#region Methoden-Ereignisse - Anfang

function g {
    param (
        #OptionalParameters
        [Parameter(Mandatory=$false)]
        [string]$s = [string]("Fairwell")
    )
    
        for ($i = 0; $i -lt $s.Length; $i++) {
            $Eingabe_Edt.Text = $s.Substring(0,$i+1); Start-Sleep -Milliseconds 500;    
        }
}


#endregion Methoden-Ereignisse - Ende


#region Ereignis-Methoden definieren - Anfang

#region Ereignisse-$button
$button_Clicked = {
    [System.Windows.Forms.MessageBox]::Show("Text!")
    $button.Text = $button.Name + " geklickt"
    $button.Font = [System.Drawing.Font]::new("Arial", 12.0)

    $form.Controls.Add($button2_Btn)
    $button2_Btn.Add_Click($button2_Btn_Clicked)
}

$button_MouseHovered = {
    $button2_Btn.BackColor = $defaultColor
    $button.BackColor = [System.Drawing.Color]::FromArgb(255,200,200,200)
    $button.Font = [System.Drawing.Font]::new("Arial", 9.0)
}
#endregion

#region Ereignisse-button2_Btn
$button2_Btn_Clicked = {
    [System.Windows.Forms.MessageBox]::Show("Text!")
    $button2_Btn.Text = $button2_Btn.Name
    $button2_Btn.Remove_Click($button2_Btn_Clicked)
    
    $form.Controls.Remove($button2_Btn) # Remove $button2_Btn from $form
}

$button2_Btn_MouseHovered = {
    $button.BackColor = $defaultColor
    $button2_Btn.BackColor = [System.Drawing.Color]::FromArgb(255,200,200,200)
}
#endregion

#region Ereignisse-Eingabe_Edt
$Eingabe_Edt_TextChanged = {
    if ($Eingabe_Edt.Text -eq "Bye") {
        
        g -s "Fairwell.";


        $form.Close()
    }
}
#endregion

#endregion Ereignis-Methoden definieren - Ende

#region Ereignis-Methoden hinzufügen - Anfang
$button.Add_Click($button_Clicked)
$button.Add_MouseHover($button_MouseHovered)

$button2_Btn.Add_Click($button2_Btn_Clicked)
$button2_Btn.Add_MouseHover($button2_Btn_MouseHovered)

$Eingabe_Edt.Add_TextChanged($Eingabe_Edt_TextChanged)
#endregion Ereignis-Methoden hinzufügen - Ende

#region UI-Elemente zum Formular hinzufügen - Anfang
$form.Controls.Add($button)
$form.Controls.Add($button2_Btn)
$form.Controls.Add($Eingabe_Edt)
#endregion UI-Elemente zum Formular hinzufügen - Ende


# Formular anzeigen bzw start der Anwendung (UI bezogen)
[void]$form.ShowDialog()


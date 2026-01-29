<# Let this program be called from other programs to perform the Mouse Move & Click.
Just one part of task automation PowerShell-Script. #>
param(
[CmdletBinding()]
[int]
$X_pos = [int]50,
[int]
$Y_pos = [int]80,
[int]
$dXX = 0,
[int]
$dYY = 0,
[switch]
$MoveTo = $false,
[switch]
$MoveRel = $false,
[switch]
$LeftClick = $false,
[switch]
$LeftClickHold = $false,
[switch]
$LeftClickRelease = $false,
[switch]
$RightClick = $false,
[switch]
$RightClickHold = $false,
[switch]
$RightClickRelease = $false,
[switch]
$CheckDug = $false,
[switch]
$askPosition = $false,
[switch]
$LOG
)

#region Keyboard

# "https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-keybd_event"
# "https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes"
#   # "https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes"
#   # "http://kbdedit.com/manual/low_level_vk_list.html"
#   # "https://defkey.com/virtual-key-codes-shortcuts"
# "https://kbdlayout.info/KBDGR/virtualkeys"
# "https://howtotypeanything.com/special-german-letters/"
# ""

$formsAssembly = [AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq 'System.Windows.Forms' }
if (-not $formsAssembly) {
    Add-Type -AssemblyName System.Windows.Forms
} else {
    if ($CheckDug -eq $true) {
        Write-Output "[System.Windows.Forms] existiert bereits.`r`n";        
    } 
}


$KeyboardSimulatorAssembly = [AppDomain]::CurrentDomain.GetAssemblies() |
    ForEach-Object {
        $_.GetTypes() | Where-Object { $_.Name -eq 'KeyboardSimulator' }
    }
if (-not $KeyboardSimulatorAssembly) {
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class KeyboardSimulator
{
    
[DllImport("user32.dll", SetLastError = true)]
    static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

    const int KEYEVENTF_KEYDOWN = 0x0000;
    const int KEYEVENTF_KEYUP = 0x0002;

    public static void KeyDown(byte keyCode)
    {
        keybd_event(keyCode, 0, KEYEVENTF_KEYDOWN, UIntPtr.Zero);
    }

    public static void KeyUp(byte keyCode)
    {
        keybd_event(keyCode, 0, KEYEVENTF_KEYUP, UIntPtr.Zero);
    }

    public static void PressKey(byte keyCode)
    {
        KeyDown(keyCode);
        KeyUp(keyCode);
    }

}
"@

} else {
    if ($CheckDug -eq $true) {
        Write-Output "[KeyboardSimulator] existiert bereits.`r`n";        
    } 
}

#region keyList
<#
0 	0x30 	0 key
1 	0x31 	1 key
2 	0x32 	2 key
3 	0x33 	3 key
4 	0x34 	4 key
5 	0x35 	5 key
6 	0x36 	6 key
7 	0x37 	7 key
8 	0x38 	8 key
9 	0x39 	9 key
	0x3A-40 	Undefined
A 	0x41 	A key
B 	0x42 	B key
C 	0x43 	C key
D 	0x44 	D key
E 	0x45 	E key
F 	0x46 	F key
G 	0x47 	G key
H 	0x48 	H key
I 	0x49 	I key
J 	0x4A 	J key
K 	0x4B 	K key
L 	0x4C 	L key
M 	0x4D 	M key
N 	0x4E 	N key
O 	0x4F 	O key
P 	0x50 	P key
Q 	0x51 	Q key
R 	0x52 	R key
S 	0x53 	S key
T 	0x54 	T key
U 	0x55 	U key
V 	0x56 	V key
W 	0x57 	W key
X 	0x58 	X key
Y 	0x59 	Y key
Z 	0x5A 	Z key
#>
#endregion keyList

function KeyPress {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [int]$Key
    )
    
    if ($Key -eq $null -or $Key -eq 0) {return;}else{[KeyboardSimulator]::PressKey($Key);}
}

# "https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.sendkeys?view=windowsdesktop-9.0"
function SendKeysWait {
    param (
        [string]$Text,
        [switch]$slow
    )
    if ($slow -eq $false) {
        if ($Text -eq $null -or $Text -eq "") {return;} else {[System.Windows.Forms.SendKeys]::SendWait("$Text")} # {ENTER}, {TAB}, {BACKSPACE}, {ESC}, {DEL}
    } else {
        for ($i = 0; $i -lt $Text.Length; $i++) {[System.Windows.Forms.SendKeys]::SendWait("$Text[$i]");Start-Sleep 1;}
    }
}

#endregion Keyboard

#region Mouse



<# add read current position -> click at moved to position (task seperation) #>
if (-not ([System.Management.Automation.PSTypeName]'MouseSimulator').Type) {
    <# queries wether type already defined #>

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public struct POINT {
    public int X;
    public int Y;
}

public class MouseSimulator {
    
    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int X, int Y);

    [DllImport("user32.dll")]
    public static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);

    public const int MOUSEEVENTF_LEFTDOWN = 0x0002;
    public const int MOUSEEVENTF_LEFTUP = 0x0004;
    public const int MOUSEEVENTF_RIGHTDOWN = 0x0008;
    public const int MOUSEEVENTF_RIGHTUP = 0x0010;
    
    public static void LeftClick(int x, int y) {
        SetCursorPos(x, y);
        mouse_event(MOUSEEVENTF_LEFTDOWN, x, y, 0, 0);
        mouse_event(MOUSEEVENTF_LEFTUP, x, y, 0, 0);
    }

    public static void LeftClickHold(int x, int y) {
        SetCursorPos(x, y);
        mouse_event(MOUSEEVENTF_LEFTDOWN, x, y, 0, 0);
        
    }

    public static void LeftClickRelease(int x, int y) {
        SetCursorPos(x, y);
        
        mouse_event(MOUSEEVENTF_LEFTUP, x, y, 0, 0);
    }

    public static void RightClick(int x, int y) {
        SetCursorPos(x, y);
        mouse_event(MOUSEEVENTF_RIGHTDOWN, x, y, 0, 0);
        mouse_event(MOUSEEVENTF_RIGHTUP, x, y, 0, 0);
    }

    public static void RightClickHold(int x, int y) {
        SetCursorPos(x, y);
        mouse_event(MOUSEEVENTF_RIGHTDOWN, x, y, 0, 0);
        
    }

    public static void RightClickRelease(int x, int y) {
        SetCursorPos(x, y);
        
        mouse_event(MOUSEEVENTF_RIGHTUP, x, y, 0, 0);
    }


    public static void Move(int x, int y){
        SetCursorPos(x, y);
    }
}
"@
} else {
    if ($CheckDug -eq $true) {
        Write-Output "[MouseSimlator] existiert bereits.`r`n";        
    } 
}


# Aktuelle Cursorposition holen
$point = New-Object POINT
[MouseSimulator]::GetCursorPos([ref]$point) | Out-Null

# Bildschirmgröße holen
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
[int]$doubleScreenWidth_int = [int]$screenWidth * 2;

# Relative Bewegung (z. B. 50 Pixel nach rechts und 30 nach unten)
$dx = $dXX
$dy = $dYY

# Neue Position berechnen
$newX = [Math]::Min([Math]::Max($point.X + $dx, 0), $doubleScreenWidth_int - 1)
$newY = [Math]::Min([Math]::Max($point.Y + $dy, 0), $screenHeight - 1)



function idleLoop {
param (
        <#OptionalParameters#>
    )
    $j = 0;
    for ($i = 0; $i -lt 100; $i++) {
        if ($j -gt 10) {$j=0;}
        if (($i%10) -eq 0) {$j++}
        [MouseSimulator]::Move($X + 5*($i%10), $Y+5*($j))
        Start-Sleep -Seconds 5
    }
}


function MoveToPosition {
    param (
        [CmdletBinding()]
        [Parameter(Mandatory=$true)]
        $X,
        [CmdletBinding()]
        [Parameter(Mandatory=$true)]
        $Y
    )
    [MouseSimulator]::Move($X, $Y);    
}
function MoveRelative {
    [MouseSimulator]::Move($newX, $newY);    
}


function askPosition {
    [MouseSimulator]::GetCursorPos([ref]$point) | Out-Null;
    $x = $point.X;
    $y = $point.Y;
    
    #Clear-Host
    Write-Output ("Mouse Position:`t" + "[X:$x|Y:$y]");
}

function MouseLeftClick {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $Log
    )
    [MouseSimulator]::GetCursorPos([ref]$point) | Out-Null;
    $x = $point.X;
    $y = $point.Y;
    [MouseSimulator]::LeftClick($x, $y);
    if ($Log){Write-Output "LMB click `t[X:$x|Y:$y]";}
}

function MouseLeftClickHold {
    param (
        #OptionalParameters
    )
    [MouseSimulator]::GetCursorPos([ref]$point) | Out-Null;
    $x = $point.X;
    $y = $point.Y;
    [MouseSimulator]::LeftClickHold($x, $y);

}

function MouseLeftClickRelease {
    param (
        #OptionalParameters
    )
    [MouseSimulator]::GetCursorPos([ref]$point) | Out-Null;
    $x = $point.X;
    $y = $point.Y;
    [MouseSimulator]::LeftClickRelease($x, $y);
    
}

function MouseRightClick {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $Log
    )
    [MouseSimulator]::GetCursorPos([ref]$point) | Out-Null;
    $x = $point.X;
    $y = $point.Y;
    [MouseSimulator]::RightClick($x, $y);
    if ($Log){Write-Output "RMB click [X:$x|Y:$y]";}
}

function MouseRightClickHold {
    param (
        #OptionalParameters
    )
    [MouseSimulator]::GetCursorPos([ref]$point) | Out-Null;
    $x = $point.X;
    $y = $point.Y;
    [MouseSimulator]::RightClickHold($x, $y);

}

function MouseRightClickRelease {
    param (
        #OptionalParameters
    )
    [MouseSimulator]::GetCursorPos([ref]$point) | Out-Null;
    $x = $point.X;
    $y = $point.Y;
    [MouseSimulator]::RightClickRelease($x, $y);
    
}



<# alternative: let the useage of dXX & dYY and X_pos & Y_pos decide. mixture allowed, but too much -> one redundant variable will be ignored #>
<# TODO: Tell what action was performed #>
<# TODO:
Add record feature with specific key listened to and write to JSON. e.g.:
    1. start record
    2. record
    3. end record
    4. save record json with chosen path/fullname 


#>

#endregion Mouse

if ($MoveTo -eq $true) {
    MoveToPosition -X $X_pos -Y $Y_pos;
} elseif ($MoveRel -eq $true) {
    MoveRelative;
}
if ($LeftClick -eq $true) {
    if ($LOG) {MouseLeftClick -Log;} else {MouseLeftClick;}
} elseif ($LeftClickHold) {
    MouseLeftClickHold;
} elseif ($LeftClickRelease) {
    MouseLeftClickRelease;
} elseif ($RightClick -eq $true) {
    if ($LOG) {MouseRightClick -Log;} else {MouseRightClick;}
} elseif ($RightClickHold) {
    MouseRightClickHold;
} elseif ($RightClickRelease) {
    MouseRightClickRelease;
}

if ($askPosition -eq $true){
    askPosition;
}

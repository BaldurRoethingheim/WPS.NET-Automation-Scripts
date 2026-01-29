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

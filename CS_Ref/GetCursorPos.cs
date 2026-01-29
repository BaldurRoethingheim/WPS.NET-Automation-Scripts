// GetCursorPos.cs

using System;
using System.Runtime.InteropServices;
public class Mouse {
    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);
    public struct POINT {
        public int X;
        public int Y;
    }
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}

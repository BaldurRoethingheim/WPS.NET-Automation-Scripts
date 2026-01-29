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
    
    // LMB
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

    // RMB
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

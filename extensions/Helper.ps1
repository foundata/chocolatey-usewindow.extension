Add-Type -Language CSharp -TypeDefinition @"
    using System;
    using System.Collections.Generic;
    using System.Runtime.InteropServices;
    using System.Text;

    public static class UseWindowHelpers
    {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool SetForegroundWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

        public static void BringToFront(IntPtr handle)
        {
            ShowWindow(handle, 5);
            SetForegroundWindow(handle);
        }


        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

        [StructLayout(LayoutKind.Sequential)]
        private struct RECT
        {
            public int Left, Top, Right, Bottom;
        }

        public static bool WindowExists(IntPtr handle)
        {
            RECT r;

            return GetWindowRect(handle, out r);
        }

        private delegate bool EnumDesktopWindowsDelegate(IntPtr hWnd, int lParam);

        [DllImport("user32.dll")]
        private static extern bool EnumDesktopWindows(IntPtr hDesktop, EnumDesktopWindowsDelegate lpfn, IntPtr lParam);

        [DllImport("user32.dll")]
        private static extern int GetWindowText(IntPtr hWnd, StringBuilder lpWindowText, int nMaxCount);

        public static List<KeyValuePair<string, IntPtr>> GetAllExistingWindows()
        {
            var windows = new List<KeyValuePair<string, IntPtr>>();

            EnumDesktopWindows(IntPtr.Zero, (h, _) =>
            {
                StringBuilder title = new StringBuilder(256);
                int titleLength = GetWindowText(h, title, 512);

                if (titleLength > 0)
                    windows.Add(new KeyValuePair<string, IntPtr>(title.ToString(), h));

                return true;
            }, IntPtr.Zero);

            return windows;
        }
    }
"@
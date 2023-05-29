Add-Type -Language CSharp -TypeDefinition @"
    using System;
    using System.Collections.Generic;
    using System.Runtime.InteropServices;
    using System.Text;

    public static class FocusWindowHelpers
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
            public int Left, Top, Right, Bottoom;
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

function Find-WindowHandle {
    <#
    .SYNOPSIS
    Finds the handle of the window matching the given query.


    .PARAMETER Query
    A query that has one of the following formats:
        - A window handle.
        - A window title followed by its handle enclosed in parentheses.
        - A RegEx pattern that is tested against all existing windows.


    .RETURNS
    An `IntPtr` matching the given query if a window is found; `IntPtr.Zero` otherwise.


    .EXAMPLE
    Find the handle of the first window having 'powershell' in its name.

    Find-WindowHandle powershell


    .EXAMPLE
    Find the handle of the first window named 'powershell'.

    Find-WindowHandle '^powershell$'


    .EXAMPLE
    Return the given handle, if a window exists with this handle.

    Find-WindowHandle 10101010


    .EXAMPLE
    Return the given handle, if a window exists with the handle at the end of the given string.

    Find-WindowHandle 'powershell (10101010)'

    #>
    param([String] $Query)

    # Find handle in title (either the whole title is the handle, or enclosed in parenthesis).
    if ($Query -match '^\d+$') {
        $Handle = [IntPtr]::new($Query)
    } elseif ($Query -match '^.+ \((\d+)\)\s*$') {
        $Handle = [IntPtr]::new($Matches[1])
    } else {
        # Find handle in existing processes.
        $MatchingWindows = [FocusWindowHelpers]::GetAllExistingWindows() | ? { $_.Key -match $Query }

        if (-not $MatchingWindows) {
            return [IntPtr]::Zero
        }

        # No need to ensure the window does exist, return immediately.
        return $MatchingWindows[0].Value
    }

    # Make sure the handle exists.
    if ([FocusWindowHelpers]::WindowExists($Handle)) {
        return $Handle
    } else {
        return [IntPtr]::Zero
    }
}

function Focus-Window {
    <#
    .SYNOPSIS
    Focuses the window having the given handle.


    .PARAMETER Query
    A window title query that will be resolved using `Find-WindowHandle`.


    .EXAMPLE
    Focus the first window having 'powershell' in its name.

    Focus-Window powershell

    #>
    param(
        [ValidateScript({
            if ( (Find-WindowHandle $_) -ne 0 ) {
                $true
            } else {
                throw "Cannot find window handle for query '$_'."
            }
        })]
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [String] $Query
    )

    $Handle = Find-WindowHandle $Query

    [FocusWindowHelpers]::BringToFront($Handle)
}


Register-ArgumentCompleter -CommandName Focus-Window -ParameterName Query -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAST, $FakeBoundParameter)

    function GetWindowTitleScore {
        <#
        .SYNOPSIS
        Returns the score of the given title when compared with the word we're currently completing.

        The score will be higher depending on which of these conditions is true:
            - The titles are equal (case-sensitive).
            - The titles are equal (case-insensitive).

            - The titles are similar (case-sensitive).
            - The titles are similar (case-insensitive).

            - The title starts with the given word (case-sensitive).
            - The title starts with the given word (case-insensitive).

            - The title contains the given word (case-sensitive).
            - The title contains the given word (case-insensitive).

        #>
        param([String] $Title)

        if (-not $Title.Length) { return 0 }

        if ($WordToComplete -ceq $Title) { return 950 }
        if ($WordToComplete -ieq $Title) { return 900 }
        if ($Title -clike $WordToComplete) { return 850 }
        if ($Title -ilike $WordToComplete) { return 800 }

        if ($Title.StartsWith($WordToComplete)) { return 750 }
        if ($Title.StartsWith($WordToComplete, $True, [cultureinfo]::InvariantCulture)) { return 700 }

        if ($Title -ccontains $WordToComplete) { return 650 }
        if ($Title -icontains $WordToComplete) { return 600 }

        0
    }

    $WindowsScores = [FocusWindowHelpers]::GetAllExistingWindows() | % {
        @{
            Title  = $_.Key;
            Handle = $_.Value;
            Score  = GetWindowTitleScore $_.Key
        }
    }

    $MatchingWindows = $WindowsScores                                               `
                        | ? { $_.Score -gt 0 }                                      `
                        | sort @{ Expression = { $_.Score }; Ascending = $False },  `
                               @{ Expression = { $_.Title }; Ascending = $True  }

    $MatchingWindows | % {
        $Title = "'$($_.Title -creplace "'", "''") ($($_.Handle))'"

        [System.Management.Automation.CompletionResult]::new(
            $Title, $Title, 'ParameterValue', $Title
        )
    }
}

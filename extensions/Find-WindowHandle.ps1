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

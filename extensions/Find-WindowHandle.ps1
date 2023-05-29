function Find-WindowHandle {
    <#
    .SYNOPSIS
        Finds the handle of the window matching the given query. Returns an
        IntPtr matching the given query if a window is found or IntPtr.Zero
        otherwise.

    .PARAMETER Query
        A query that has one of the following formats:

        - A RegEx pattern that is tested against all existing windows.
        - A window handle.
        - A window title followed by its handle enclosed in parentheses.

    .EXAMPLE
        Find the handle of the first window having "powershell" somewhere
        in its name:

            Find-WindowHandle 'powershell'

    .EXAMPLE
        Find the handle of the first window named exactly "powershell":

            Find-WindowHandle '^powershell$'

    .EXAMPLE
        Return the given handle, if a window exists with this handle:

            Find-WindowHandle 10101010

    .EXAMPLE
        Return the given handle, if a window exists with the handle at the
        end of the given string:

            Find-WindowHandle 'powershell (10101010)'

    #>
    Param(
        [Parameter(Mandatory = $True,
                   HelpMessage = 'A RegEx pattern that is tested against all existing windows OR a window handle OR a window title followed by its handle enclosed in parentheses.')]
        [String]$Query
    )

    # find handle in title (either the whole title is the handle, or enclosed in parenthesis)
    if ($Query -match '^\d+$') {
        $Handle = [IntPtr]::new($Query)
    } elseif ($Query -match '^.+ \((\d+)\)\s*$') {
        $Handle = [IntPtr]::new($Matches[1])
    } else {

        # find handle in existing processes.
        $MatchingWindows = [UseWindowHelpers]::GetAllExistingWindows() | ? { $PSItem.Key -match $Query }

        if (-not $MatchingWindows) {
            return [IntPtr]::Zero
        }

        # no need to ensure the window does exist, return immediately
        return $MatchingWindows[0].Value
    }

    # make sure the handle exists
    if ([UseWindowHelpers]::WindowExists($Handle)) {
        return $Handle
    } else {
        return [IntPtr]::Zero
    }
}

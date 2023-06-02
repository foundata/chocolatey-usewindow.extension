function Use-Window {
    <#
    .SYNOPSIS
        Focuses the window having the given handle and brings it to the front.

    .PARAMETER Query
        A window title query that will be resolved using "Find-WindowHandle".

    .EXAMPLE
        Focus the first window having "powershell" somewhere in its name and
        bring it to the front:

            Use-Window "powershell"

    .EXAMPLE
        Focus the first window named exactly "powershell" and bring it to the
        front:

            Use-Window'^powershell$'
    #>
    Param(
        [Parameter(Mandatory = $True,
                   ValueFromPipeline = $True,
                   HelpMessage = 'A window title query that will be resolved using "Find-WindowHandle".')]
        [ValidateScript({
            if ( (Find-WindowHandle $PSItem) -eq 0 ) {
                Throw "Use-Window: Cannot find window handle for query '${PSItem}'."
            } else {
                $True
            }
        })]
        [String]$Query
    )

    $Handle = Find-WindowHandle $Query

    [UseWindowHelpers]::BringToFront($Handle)
}

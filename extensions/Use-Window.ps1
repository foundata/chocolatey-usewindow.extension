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
        [ValidateScript({
            if ( (Find-WindowHandle $PSItem) -ne 0 ) {
                $true
            } else {
                throw "Cannot find window handle for query '$PSItem'."
            }
        })]
        [Parameter(Mandatory = $True,
                   ValueFromPipeline = $True,
                   HelpMessage = 'A window title query that will be resolved using "Find-WindowHandle".')]
        [String]$Query
    )

    $Handle = Find-WindowHandle $Query

    [UseWindowHelpers]::BringToFront($Handle)
}

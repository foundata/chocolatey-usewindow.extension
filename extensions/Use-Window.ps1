function Use-Window {
    <#
    .SYNOPSIS
    Focuses the window having the given handle.


    .PARAMETER Query
    A window title query that will be resolved using `Find-WindowHandle`.


    .EXAMPLE
    Focus the first window having 'powershell' in its name.

    Use-Window powershell

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

    [UswWindowHelpers]::BringToFront($Handle)
}

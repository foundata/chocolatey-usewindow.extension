#Requires -Version 5.0
$ErrorActionPreference = 'Stop' # stop on all errors

$scriptRoot = Split-Path $MyInvocation.MyCommand.Definition

# get currently defined functions (before sourcing additional .ps1 files)
$functionsBefore = Get-ChildItem 'Function:\*'

# source files whose names start with a capital letters, ignore others
Get-ChildItem "${scriptRoot}\*.ps1" | Where-Object { $PSItem.Name -cmatch '^[A-Z]+' } | ForEach-Object { . $PSItem  }

# get currently defined functions (after sourcing additional .ps1 files)
$functionsAfter = Get-ChildItem 'Function:\*'

# export functions whose names start with a capital letter, others are private
$functionsDiff = Compare-Object $functionsBefore $functionsAfter | Select-Object -ExpandProperty 'InputObject' | Select-Object -ExpandProperty 'Name'
$functionsDiff | Where-Object { $PSItem -cmatch '^[A-Z]+'} | ForEach-Object { Export-ModuleMember -Function $PSItem }
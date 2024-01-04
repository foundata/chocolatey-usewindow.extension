<#
.SYNOPSIS
    PowerShell Module file that ensures all needed functions and resources are
    available.

.NOTES
    SPDX-License-Identifier: MIT
    SPDX-FileCopyrightText: foundata GmbH <https://foundata.com>
#>

$ErrorActionPreference = 'Stop' # stop on all errors

$scriptRoot = Split-Path $MyInvocation.MyCommand.Definition

# get currently defined functions (before dot sourcing additional .ps1 files)
$functionsBefore = Get-ChildItem 'Function:\*'

# dot source files whose names start with a capital letter, ignore others
Get-ChildItem "${scriptRoot}\*.ps1" | Where-Object { $PSItem.Name -cmatch '^[A-Z]+' } | ForEach-Object { . $PSItem  }

# get currently defined functions (after dot sourcing additional .ps1 files)
$functionsAfter = Get-ChildItem 'Function:\*'

# export functions whose names start with a capital letter, others are private
$functionsDiff = Compare-Object $functionsBefore $functionsAfter | Select-Object -ExpandProperty 'InputObject' | Select-Object -ExpandProperty 'Name'
$functionsDiff | Where-Object { $PSItem -cmatch '^[A-Z]+'} | ForEach-Object { Export-ModuleMember -Function $PSItem }
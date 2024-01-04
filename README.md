# Use-Window extension for Chocolatey (helper to focus a window) (`usewindow.extension`)

**This project is *not* associated with the official [Chocolatey](https://chocolatey.org/) product or team, nor with [Chocolatey Software, Inc.](https://chocolatey.org/contact/).**

A [Chocolatey extension](https://docs.chocolatey.org/en-us/features/extensions) providing helper functions for querying and focusing windows. These functions may be used in Chocolatey install and uninstall scripts by declaring this package a dependency in your package's `.nuspec`.

The most important function is `Use-Window`, which is able to focus a window and bring it to the front. A script can easily switch between windows this way.


## Installation

As the package is an extension, it gets usually installed automatically as a dependency. However, you can still install it manually:

```console
choco install usewindow.extension
```


## Usage

To create a package with the ability to use a function from this extension, add the following to your `.nuspec` specification:

```xml
<dependencies>
  <dependency id="usewindow.extension" version="REPLACE_WITH_MINIMUM_VERSION_USUALLY_CURRENT_LATEST" />
</dependencies>
```

It is possible to import the module directly in your `PS >`, so you can try out the main functionality directly:

```powershell
# import the modules
Import-Module "${env:ChocolateyInstall}\helpers\chocolateyInstaller.psm1"
Import-Module "${env:ChocolateyInstall}\extensions\usewindow\*.psm1"

# get a list of all functions
Get-Command -Module 'usewindow.extension'

# get help and examples for a specific function
Get-Help Use-Window -Detailed
Get-Help Find-WindowHandle -Detailed

# bring the first window that contains the name 'foo' to the front and focus it
Use-Window 'foo'

# bring the first window that equals the name 'foo' to the front and focus it
Use-Window '^foo$'

# bring the first window with the handle 101010, if it exist, to the front and focus it.
Use-Window 101010

# focus the window with the handle 202020, if it exists, to the front and focus it.
Use-Window 'foo bar (202020)'
```

But keep in mind that functions of Chocolatey extension may only work correctly in the context of Chocolatey install and uninstall scripts.


## Licensing, copyright

<!--REUSE-IgnoreStart-->
Copyright (c) 2018 Grégoire Geis (https://github.com/71/Focus-Window/)
Copyright (c) 2022 Refactoring UI Inc. (https://github.com/tailwindlabs/heroicons/blob/master/optimized/24/outline/window.svg)
Copyright (c) 2023, 2024 foundata GmbH (https://foundata.com)

This project is licensed under the MIT License (SPDX-License-Identifier: `MIT`), see [`LICENSES/MIT.txt`](LICENSES/MIT.txt) for the full text.

The [`.reuse/dep5`](.reuse/dep5) file provides detailed licensing and copyright information in a human- and machine-readable format. This includes parts that may be subject to different licensing or usage terms, such as third party components. The repository conforms to the [REUSE specification](https://reuse.software/spec/), you can use [`reuse spdx`](https://reuse.readthedocs.io/en/latest/readme.html#cli) to create a [SPDX software bill of materials (SBOM)](https://en.wikipedia.org/wiki/Software_Package_Data_Exchange).
<!--REUSE-IgnoreEnd-->

[![REUSE status](https://api.reuse.software/badge/github.com/foundata/chocolatey-usewindow.extension)](https://api.reuse.software/info/github.com/foundata/chocolatey-usewindow.extension)


## Author information

This Chocolatey extension is maintained by [foundata](https://foundata.com/). If you like it, you might [buy them a coffee](https://buy-me-a.coffee/chocolatey-usewindow.extension/). This is a community project and *not* associated with the official [Chocolatey](https://chocolatey.org/) product or team, nor with [Chocolatey Software, Inc.](https://chocolatey.org/contact/). The core functionality is a fork of the [`Focus-Window`](https://github.com/71/Focus-Window/) PowerShell module by [Grégoire Geis](https://gregoirege.is/).

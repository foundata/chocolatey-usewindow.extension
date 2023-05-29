# Chocolatey Use-Window extension (helper to focus a window) (`chocolatey-usewindow.extension`)

A [Chocolatey extension](https://docs.chocolatey.org/en-us/features/extensions) providing helper functions for querying and focusing windows. These functions may be used in Chocolatey install and uninstall scripts by declaring this package a dependency in your package's `.nuspec`.

The most important function is `Use-Window`, which is able to focus a window and bring it to the front. A script can easily switch between windows this way.


## Installation

As the package is an extension, it gets usually installed automatically as a dependency. However, you can still install it manually:

```console
choco install chocolatey-usewindow.extension
```


## Usage

To create a package with the ability to use a function from this extension, add the following to your `.nuspec` specification:

```xml
<dependencies>
  <dependency id="chocolatey-usewindow.extension" version="REPLACE_WITH_MINIMUM_VERSION_USUALLY_CURRENT_LATEST" />
</dependencies>
```

It is possible to import the module directly in your `PS >`, so you can try out the main functionality directly:

```powershell
# import the modules
Import-Module "${env:ChocolateyInstall}\helpers\chocolateyInstaller.psm1"
Import-Module "${env:ChocolateyInstall}\extensions\chocolatey-usewindow\*.psm1"

# get a list of all functions
Get-Command -Module 'chocolatey-usewindow.extension'

# get help for a specific function
Get-Help Find-WindowHandle
Get-Help Use-Window

# focus the first window that contains the name 'foo'.
Use-Window foo

# focus the first window that equals the name 'foo'.
Use-Window '^foo$'

# focus the window with the handle 101010, if it exists.
Use-Window 101010

# focus the window with the handle 202020, if it exists.
Use-Window 'foo bar (202020)'
```

But keep in mind that functions of Chocolatey extension may only work correctly in the context of Chocolatey install and uninstall scripts.


## License, copyright

This project is under the MIT License. See the [`LICENSE`](./LICENSE) file for the full license text and details.


## Author information

This Chocolatey extension is maintained by [foundata](https://foundata.com/). If you like it, you might [buy them a coffee](https://buy-me-a.coffee/chocolatey-usewindow.extension/). The core functionality is a fork of the [`Focus-Window`](https://github.com/71/Focus-Window/) PowerShell module by [Grégoire Geis](https://gregoirege.is/).

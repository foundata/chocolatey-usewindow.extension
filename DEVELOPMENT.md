# Development

This file provides additional information for maintainers and contributors.


## Testing

Nothing special or automated yet. For the time being, try *at least*:

1. Build the nupkg package, install it and watch out for errors and warnings:
   ```console
   cd ./chocolatey-usewindow.extension
   choco pack
   choco install chocolatey-usewindow.extension --source='.\' --force
   RefreshEnv
   ```
2. Import the PowerShell module directly, do some function calls and watch out for errors. See the [`README.md` "Usage" section](./README.md#usage) for details.
3. Check if the installation of packages depending on this extension is still working properly:
   ```console
   choco install `
     chocolatey-sendkeys.extension `
     chocolatey-sendmouseclick.extension `
     --force
   ```


## Releases

1. Do proper [Testing](#testing). Continue only if everything is fine.
2. Determine the next version number. This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Unlike other Chocolatey packages, there is no underlying software's version to match.
3. Update the [`CHANGELOG.md`](./CHANGELOG.md). Insert a section for the new release. Do not forget the comparison link at the end of the file.
4. If everything is fine: commit the changes, tag the release and push:
   ```console
   git tag v<version> <commit> -m "version <version>"
   git show v<version>
   git push origin main --follow-tags
   ```
5. Compile the `.nupkg` and [Push](https://docs.chocolatey.org/en-us/create/commands/push) it to the community package feed.


## Miscellaneous

### Encoding

* Generally: Use UTF-8 encoding with `LF` (Line Feed `\n`) line endings.
* All `*.ps1`, `psm1` and `*.nuspec` files: Please follow [Chocolatey's character encoding rules](https://docs.chocolatey.org/en-us/create/create-packages#character-encoding). Add a Byte Order Mark (BOM) and use `CRLF` (Carriage Return `\r` and Line Feed `\n`) line endings as Chocolatey's general context is Microsoft Windows, Powershell and .NET.


### Repository name prefix vs. package ID

We established `chocolatey-<packageID>` as naming rule for Chocolatey package source repositories.

However, as it is also common to use `chocolatey-` as prefix for package IDs of Chocolatey extensions, we decided to define an exemption: The `chocolatey-` repository prefix is dropped when the packages ID also start's with `chocolatey-`.

Strictly following the naming rule would result in unhandy repository names like `chocolatey-chocolatey-usewindow.extension` otherwise, without any real benefit regarding grouping and filtering.
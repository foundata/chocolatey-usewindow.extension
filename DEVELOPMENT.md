# Development

This file provides additional information for maintainers and contributors.


## Testing

Nothing special or automated yet. For the time being, try *at least*:

1. Build the nupkg package, install it and watch out for errors and warnings:
   ```console
   cd ./chocolatey-usewindow.extension
   choco pack
   choco install usewindow.extension --source='.\' --force
   RefreshEnv
   ```
2. Import the PowerShell module directly, do some function calls and watch out for errors. See the [`README.md` "Usage" section](./README.md#usage) for details.
3. Check if the installation of packages depending on this extension is still working properly:
   ```console
   choco install `
     sendkeys.extension `
     sendmouseclick.extension `
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
   If something minor went wrong (like missing `CHANGELOG.md` update), delete the tag and start over:
   ```console
   git tag -d v<version>                 # delete the old tag locally
   git push origin :refs/tags/v<version> # delete the old tag remotely
   ```
   This is *only* possible if the package was not already [pushed](https://docs.chocolatey.org/en-us/create/commands/push) to the community package feed. Use a new patch version number otherwise.
5. Compile the `.nupkg` and [Push](https://docs.chocolatey.org/en-us/create/commands/push) it to the community package feed.


## Miscellaneous

### Encoding

* Generally: Use UTF-8 encoding with `LF` (Line Feed `\n`) line endings.
* All `*.ps1`, `psm1` and `*.nuspec` files: Please follow [Chocolatey's character encoding rules](https://docs.chocolatey.org/en-us/create/create-packages#character-encoding). Add a Byte Order Mark (BOM) and use `CRLF` (Carriage Return `\r` and Line Feed `\n`) line endings as Chocolatey's general context is Microsoft Windows, Powershell and .NET.

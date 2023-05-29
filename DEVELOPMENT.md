# Development

This file provides additional information for maintainers and contributors.


## Testing

Nothing special or automated yet. For the time being, try *at least*:

1. Build the nupkg package and install it:
   ```console
   cd ./chocolatey-usewindow.extension
   choco pack
   choco install chocolatey-usewindow.extension --source='.\' --force
   RefreshEnv
   ```
3. Try to import the module directly and call some functions. See the [`README.md` "Usage" section](./README.md#usage) for details.
4. Check if the installation of packages depending on this extension is still working properly:
   ```console
   choco install `
     chocolatey-sendkeys.extension `
     chocolatey-sendmouseclick.extension `
     --force
   ```


## Releases

1. Do proper [Testing](#testing). Continue only if everything is fine.
2. Determine the next version number. This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Unlike other Chocolatey packages, there is no underlying software's version to match.
3. Update the `CHANGELOG.md`(./CHANGELOG.md). Insert a section for the new release. Do not forget the comparison link at the end of the file.
4. Tag the release and push upstream if everything is fine:
   ```console
   git tag v<version> <commit> -m "version <version>"
   git show v<version>
   git push origin main --follow-tags
   ```
5. [Push](https://docs.chocolatey.org/en-us/create/commands/push) the compiled nupkg to the community package feed.


## Miscellaneous

### Encoding

Chocolatey's general context is Microsoft Windows, Powershell and .NET. Please follow the fitting [character encoding rules](https://docs.chocolatey.org/en-us/create/create-packages#character-encoding):

* Use UTF-8 encoding for all files.
* Add a Byte Order Mark (BOM) and use CRLF line endings for all `*.ps1`, `psm1` and `*.nuspec` files.


### Repository name prefix vs. package ID

We established `chocolatey-<packageID>` as naming rule for Chocolatey package source repositories.

However, as it is also common to use `chocolatey-` as prefix for package IDs of Chocolatey extensions, we decided to define an exemption: The `chocolatey-` repository prefix is dropped when the packages ID also start's with `chocolatey-`.

Strictly following the naming rule would result in unhandy repository names like `chocolatey-chocolatey-usewindow.extension` otherwise, without any real benefit regarding grouping and filtering.
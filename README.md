# flakelight-elisp

Elisp module for [flakelight][1].

[1]: https://github.com/nix-community/flakelight

## Additional options

Set `elispPackages` to an attribute set of package definitions for Elisp
packages.

`elispPackages` is autoloaded from the `elispPackages`,
`packages/elispPackages`, or `packages/elisp-packages` subdirectories of your
`nixDir` directory.

## Configured options

Adds configured Elisp packages to the `withOverlays` and `overlays` options.

Adds build checks for the Elisp packages.

## Example flake

```nix
{
  inputs.flakelight-elisp.url = "github:accelbread/flakelight-elisp";
  outputs = { flakelight-elisp, ... }: flakelight-elisp ./. {
    elispPackages.packageName = { elpaBuild }:
      elpaBuild {
        # package build configuration
      };
  };
}
```

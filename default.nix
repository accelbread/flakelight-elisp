# flakelite-elisp -- Elisp module for flakelite
# Copyright (C) 2023 Archit Gupta <archit@accelbread.com>
#
# SPDX-License-Identifier: MIT

src: inputs: root:
let
  inherit (inputs.nixpkgs.lib) findFirst optionalAttrs mapAttrs' nameValuePair;
  inherit (inputs.flakelite.lib) autoloadAttr ensureFn genPackages;

  params = inputs.flakelite.lib // { inherit src inputs root; };
  applyParams = v: ensureFn v params;

  elispPackage = findFirst (x: x != null) null [
    (root.elispPackage or null)
    (autoloadAttr root.nixDir "elispPackage")
  ];

  elispPackages = findFirst (x: x != null) { } [
    (root.elispPackages or null)
    (autoloadAttr root.nixDir "elispPackages")
    (autoloadAttr (root.nixDir + /packages) "elispPackages")
    (autoloadAttr (root.nixDir + /packages) "elisp-packages")
  ];

  elispPackages' = (applyParams elispPackages) //
    optionalAttrs (elispPackage != null) { "${root.name}" = elispPackage; };
in
rec {
  withOverlay = _: prev: {
    emacsPackagesFor = emacs: (prev.emacsPackagesFor emacs).overrideScope'
      (final: _: genPackages final elispPackages');
  };
  overlay = withOverlay;
  checks = { emacs, ... }: mapAttrs'
    (k: v: nameValuePair ("elispPackages-" + k) emacs.pkgs.${k})
    elispPackages';
}

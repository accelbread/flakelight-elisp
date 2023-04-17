# flakelite-elisp -- Elisp module for flakelite
# Copyright (C) 2023 Archit Gupta <archit@accelbread.com>
#
# SPDX-License-Identifier: MIT

{ root, lib, flakelite, args }:
let
  inherit (lib) findFirst optionalAttrs mapAttrs' nameValuePair;
  inherit (flakelite) autoImport callFn callPkgs;

  elispPackage = findFirst (x: x != null) null [
    (root.elispPackage or null)
    (autoImport root.nixDir "elispPackage")
  ];

  elispPackages = findFirst (x: x != null) { } [
    (root.elispPackages or null)
    (autoImport root.nixDir "elispPackages")
    (autoImport (root.nixDir + /packages) "elispPackages")
    (autoImport (root.nixDir + /packages) "elisp-packages")
  ];

  elispPackages' = (callFn args elispPackages) //
    optionalAttrs (elispPackage != null) { "${root.name}" = elispPackage; };
in
rec {
  withOverlay = _: prev: {
    emacsPackagesFor = emacs: (prev.emacsPackagesFor emacs).overrideScope'
      (final: _: callPkgs final elispPackages');
  };
  overlay = withOverlay;
  checks = { emacs }: mapAttrs'
    (k: v: nameValuePair ("elispPackages-" + k) emacs.pkgs.${k})
    elispPackages';
}

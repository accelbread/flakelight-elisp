# flakelight-elisp -- Elisp module for flakelight
# Copyright (C) 2023 Archit Gupta <archit@accelbread.com>
#
# SPDX-License-Identifier: MIT

{ config, lib, flakelight, moduleArgs, ... }:
let
  inherit (lib) mapAttrs mapAttrs' mkIf mkMerge mkOption nameValuePair;
  inherit (lib.types) lazyAttrsOf;
  inherit (flakelight) autoImport;
  inherit (flakelight.types) optCallWith packageDef;

  autoLoads = autoImport config.nixDir [
    "elispPackages"
    "packages/elispPackages"
    "packages/elisp-packages"
  ];
in
{
  options.elispPackages = mkOption {
    type = optCallWith moduleArgs (lazyAttrsOf packageDef);
    default = { };
  };

  config = mkMerge [
    (mkIf (autoLoads != null) { elispPackages = autoLoads; })

    (mkIf (config.elispPackages != { }) rec {
      overlay = _: prev: {
        emacsPackagesFor = emacs: (prev.emacsPackagesFor emacs).overrideScope'
          (final: _:
            mapAttrs (_: v: final.callPackage v { }) config.elispPackages);
      };

      withOverlays = overlay;

      checks = { emacs, ... }: mapAttrs'
        (k: v: nameValuePair ("elispPackages-" + k) emacs.pkgs.${k})
        config.elispPackages;
    })
  ];
}

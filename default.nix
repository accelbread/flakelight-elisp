# flakelite-elisp -- Elisp module for flakelite
# Copyright (C) 2023 Archit Gupta <archit@accelbread.com>
#
# SPDX-License-Identifier: MIT

src: inputs: root: rec {
  withOverlay = _: prev: {
    emacsPackagesFor = emacs: (prev.emacsPackagesFor emacs).overrideScope'
      (final: _: builtins.mapAttrs
        (_: v: final.callPackage v { })
        ((root.elispPackages or { }) //
          (if root ? elispPackage then {
            "${root.name}" = root.elispPackage;
          } else { })));
  };
  overlay = withOverlay;
}

# flakelight-elisp -- Elisp module for flakelight
# Copyright (C) 2023 Archit Gupta <archit@accelbread.com>
#
# SPDX-License-Identifier: MIT

{
  inputs.flakelight.url = "github:nix-community/flakelight";
  outputs = { flakelight, ... }: flakelight ./. {
    imports = [ flakelight.flakelightModules.extendFlakelight ];
    flakelightModule = ./flakelight-elisp.nix;
  };
}

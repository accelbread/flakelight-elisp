# flakelite-elisp -- Elisp module for flakelite
# Copyright (C) 2023 Archit Gupta <archit@accelbread.com>
#
# SPDX-License-Identifier: MIT

{
  inputs.flakelite.url = "github:accelbread/flakelite";
  outputs = { flakelite, ... }@inputs:
    flakelite.lib.mkFlake ./. inputs {
      outputs.flakeliteModule = import ./.;
    };
}

{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim.plugins.which-key = {
        enable = true;
    };
}

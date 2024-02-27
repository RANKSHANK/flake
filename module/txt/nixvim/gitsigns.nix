{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins.gitsigns = {
            enable = true;
        };
    };
}

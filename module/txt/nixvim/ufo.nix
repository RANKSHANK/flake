{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins.nvim-ufo = {
            enable = true;
        };
        opts = {
            foldlevelstart = 99;
        };
    };
}

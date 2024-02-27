{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins.harpoon = {
            enable = true;
        };
    };
}

{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins.noice = {
            enable = true;
        };
    };
}

{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins.cursorline = {
            enable = true;
            cursorword = {
                enable = true;
            };
            cursorline = {
                enable = true;
            };
        };
    };
}

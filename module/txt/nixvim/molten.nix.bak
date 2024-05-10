{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins = {
            molten = {
                enable = true;
            };
        };
    };
}

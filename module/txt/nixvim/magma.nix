{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins = {
            magma-nvim = {
                enable = true;
            };
        };
    };
}

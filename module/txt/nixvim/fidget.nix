{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins.fidget = {
            enable = true;
        };
    };
}

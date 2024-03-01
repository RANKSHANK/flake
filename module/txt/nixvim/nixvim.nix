{ config, lib, pkgs, ... }:

lib.mkModule "nixvim" [ "shell" ] config {
    programs.neovim.defaultEditor = true;

    programs.nixvim = {
        enable = true;
        globals = {
            mapleader = " ";
            localleader = ",";
        };
        extraPlugins = builtins.attrValues {
            inherit (pkgs.vimPlugins) nvim-web-devicons;
        };
    };
}

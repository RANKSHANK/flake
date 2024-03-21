{ config, lib, pkgs, ... }:

lib.mkModule "nixvim" [ "shell" ] config {

    home-manager.sharedModules = [({ ... }: {
        home.sessionVariables = {
            EDITOR = "nvim";
            VISUAL = "nvim";
        };
    })];

    programs.neovim.defaultEditor = true;

    environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
    };

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

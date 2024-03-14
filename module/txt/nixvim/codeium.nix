{ config, lib, inputs, pkgs, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins = {
            codeium-nvim = {
                enable = true;
                package = inputs.codeium.packages.${pkgs.system}.vimPlugins.codeium-nvim;
            };
             cmp.settings.sources = [{
                name = "codeium";
                priority = 5;
                groupIndex = 1;
            }];
        };
    };
}

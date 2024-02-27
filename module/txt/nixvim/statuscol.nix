{ config, lib, pkgs, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        extraPlugins = builtins.attrValues {
            inherit (pkgs.vimPlugins) statuscol-nvim;
        };

        extraConfigLua = ''
            require("statuscol").setup({
                segments = {
                };
            })
        '';
    };
}

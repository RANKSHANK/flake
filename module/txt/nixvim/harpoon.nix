{ config, lib, pkgs, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
    plugins = {
        harpoon = {
            enable = true;
            markBranch = true;
            package = pkgs.vimPlugins.harpoon2;
        };
        which-key.registrations = lib.listToAttrs (builtins.genList (i: {
            name = "<leader>${toString i}";
            value = "which_key_ignore";
        }) 10);
    };
        keymaps = let
            fn = str: ''
            function()
                local harpoon = require("harpoon")
                ${str}
            end'';
        in lib.flatten [
            {
                key = "<leader>a";
                action.__raw = fn "harpoon:list():append()";
                # lua = true;
                options.desc = "Harpoon Append";
            }
            {
                key = "<leader>h";
                action.__raw = fn "harpoon.ui:toggle_quick_menu(harpoon:list())";
                # lua = true;
                options.desc = "Harpoon Menu";
            }
            (builtins.genList (i: {
                key = "<leader>${toString i}";
                action.__raw = fn "harpoon:list():select(${toString i})";
                # lua = true;
            }) 10)
        ];
    };
}

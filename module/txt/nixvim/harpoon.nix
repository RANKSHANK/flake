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
                action = fn "harpoon:list():append()";
                lua = true;
                options.desc = "Harpoon Add";
            }
            {
                key = "<leader>h";
                action = fn "harpoon.ui:toggle_quick_menu(harpoon:list())";
                lua = true;
                options.desc = "Harpoon Menu";
            }
            (builtins.genList (i: {
                key = "<leader>${toString i}";
                action = fn "harpoon:list():select(${toString i})";
                lua = true;
            }) 10)
        ];
    };
}

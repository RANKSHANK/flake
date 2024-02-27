{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {

    programs.nixvim = {

        plugins.oil = {
            enable = true;
            defaultFileExplorer = true;
            columns = {
                icon.enable = true;
            };
        };

        keymaps = [
            {
                key = "<leader>e";
                action = "<cmd>lua require('oil').open()<cr>";
                options.desc = "Open Oil";
                mode = [ "n" "x" "o" ];
            }
        ];
    };
}

{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {

    programs.nixvim = {

        plugins.oil = {
            enable = true;
            settings = {
                default_file_explorer = true;
                columns = [
                    "icon"
                    "size"
                ];
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

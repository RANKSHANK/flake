{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins = {
            codeium-vim = { # codeium.nvim isn't feature complete
                enable = true;
                keymaps = {
                    accept = "<C-space>";
                };
            };
            #  cmp.settings.sources = [{
            #     name = "codeium";
            #     priority = 5;
            #     groupIndex = 1;
            # }];
        };
    };
}

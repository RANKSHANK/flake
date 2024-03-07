{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins = {
            cmp = {
                enable = true;
                settings = {
                    preselect = "cmp.PreselectMode.None";
                    sources = [
                    {
                        name = "path";
                        priority = 1;
                        groupIndex = 1;
                    }
                    {
                        name = "nvim_lsp";
                        priority = 2;
                        groupIndex = 1;
                    }
                    {
                        name = "luasnip";
                        priority = 3;
                        groupIndex = 1;
                    }
                    {
                        name = "buffer";
                        priority = 4;
                        groupIndex = 1;
                    }
                    {
                        name = "greek";
                        priority = 1;
                        groupIndex = 2;
                    }
                    {
                        name = "spell";
                        keywordLength = 3;
                        priority = 1;
                        groupIndex = 3;
                    }
                    ];
                    experimental.ghost_text.enable = true;
                    mapping = let
                        select = str: "cmp.mapping.select_${str}_item({ behavior = cmp.SelectBehavior.Insert })";
                    scroll = num: "cmp.mapping.scroll_docs(${toString num})";
                    confirm = bool: "cmp.mapping.confirm({ select = ${lib.ternary bool "true" "false"} })";
                    in {
                        "<C-n>" = select "next";
                        "<Tab>" = select "next";
                        "<C-p>" = select "prev";
                        "<S-Tab>" = select "prev";
                        "<C-f>" = scroll (-4);
                        "<C-b>" = scroll 4;
                        "<C-e>" = "cmp.mapping.abort()";
                        "<C-c>" = confirm true;
                        "<CR>" = confirm false;
                    };
                };
            };
        };
    };
}

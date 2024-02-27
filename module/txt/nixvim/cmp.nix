{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins = {
            nvim-cmp = {
                enable = true;
                preselect = "None";
                sources = [
                    {
                        name = "path";
                        priority = 1;
                    }
                    { 
                        name = "nvim_lsp";
                        priority = 2;
                    }
                    {
                        name = "luasnip";
                        priority = 3;
                    }
                    {
                        name = "buffer";
                        priority = 4;
                    }
                    {
                        name = "greek";
                        priority = 4;
                    }
                    {
                        name = "spell";
                        keywordLength = 3;
                        priority = 6;
                    }
                ];
                mapping = let
                    select = str: "cmp.mapping.select_${str}_item({ behavior = cmp.SelectBehavior.Insert })";
                    scroll = num: "cmp.mapping.scroll_docs(${toString num})";
                    confirm = bool: "cmp.mapping.confirm({ select = ${lib.ternary bool "true" "false"} })";
                in {
                    "<C-n>" = select "next";
                    "<Tab>" = select "next";
                    "<C-p>" = select "prev";
                    "<S-Tab>" = select "prev";
                    "<C-j>" = scroll (-4); # needs parens for some reason
                    "<C-f>" = scroll (-4); #TODO: investigate
                    "<C-k>" = scroll 4;
                    "<C-b>" = scroll 4;
                    "<C-e>" = "cmp.mapping.abort()";
                    "<C-c>" = confirm true;
                    "<CR>" = confirm false;
                };
                experimental.ghost_text.enable = true;
            };
        };
    };
}

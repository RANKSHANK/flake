{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins = {
            luasnip = {
                enable = true;
                extraConfig = {
                    enable_autosnippets = true;
                    store_selection_keys = "<Tab>";
                };
            };
            friendly-snippets = {
                enable = true;
            };
        };
        #keymaps = let
        #    jump = num: "function() return require('luasnip').jump(${toString num}) end";
        #in [
        #    {
        #        key = "<Tab>";
        #        action = ''function()
        #            return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
        #        end'';
        #        mode = [ "i" ];
        #        options = {
        #            desc = "LuaSnip";
        #            expr = true;
        #            silent = true;
        #        };
        #    }
        #    {
        #        key = "<Tab>";
        #        action = jump 1;
        #        mode = [ "s" ];
        #        options.desc = "LuaSnip Next";
        #    }
        #    {
        #        key = "<S-Tab>";
        #        action = jump (-1) ;
        #        mode = [ "i" "s" ];
        #        options.desc = "LuaSnip Prev";
        #    }
        #];
    };
}

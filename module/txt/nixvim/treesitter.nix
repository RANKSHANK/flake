{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins = { 
            treesitter = {
                enable = true;
                indent = true;
                nixvimInjections = true;
            };

            treesitter-context = {
                enable = true;
            };

            treesitter-textobjects = {
                enable = true;
            };

            rainbow-delimiters = {
                enable = true;
            };
        };
    };

}

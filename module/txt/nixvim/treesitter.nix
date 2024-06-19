{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins = {
            treesitter = {
                enable = true;
                nixvimInjections = true;
                settings = {
                    indent = {
                        enable = true;
                    };
                };
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

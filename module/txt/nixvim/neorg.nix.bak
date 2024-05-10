{ config, lib, pkgs, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        extraPlugins = builtins.attrValues {
            inherit (pkgs.vimPlugins) nabla-nvim;
        };
        keymaps = [
        {
            action = ''function()
                require("nabla").popup({ border = "rounded", })
                end'';
            key = "<leader>m";
            options.desc = "Hover Math";
            lua = true;
        }
        ];
        plugins = {
            neorg = {
                enable = true;
                lazyLoading = true;
                modules = let
                    empty = { __empty = null; };
                in {
                    "core.defaults" = empty;
                    "core.concealer" = empty;
                    "core.dirman" = {
                        config = {
                            workspaces = {
                                notes = "$XDG_DOCUMENTS_DIR/notes";
                            };
                        };
                    };
                    "core.integrations.telescope" = empty;
                    # "core.ui.calendar" = empty;
                    "core.summary" = empty;
                };
            };
            image = {
                enable = true;
                backend = "ueberzug";
                integrations = {
                    neorg = {
                        enabled = true;
                    };
                    markdown = {
                        enabled = true;
                    };
                };
            };
        };

      };
}

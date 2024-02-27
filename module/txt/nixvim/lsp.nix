{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins = {
            lsp-lines = {
                enable = true;
            };
            lsp = {
                enable = true;
                keymaps = {
                    diagnostic = {
                        "<leader>k" = {
                             action = "goto_next";
                             desc = "Next Diagnostic";
                        };
                        "<leader>j" = {
                             action = "goto_prev";
                             desc = "Prev Diagnostic";
                        };
                    };
                    lspBuf = {
                        "K" = {
                            action = "hover";
                            desc = "Hover";
                        };
                        "gD" = {
                            action = "references";
                            desc = "Goto Refs";
                        };
                        "gd" = {
                            action = "definition";
                            desc = "Goto Defs";
                        };
                        "gi" = {
                            action = "implementation";
                            desc = "Goto Impl";
                        };
                        "gt" = {
                            action = "type_definition";
                            desc = "Goto Type Def";
                        };
                        "cr" = {
                            action = "rename";
                            desc = "Rename";
                        };
                        "<C-k>" = {
                            action = "signature_help";
                            desc = "Signature Help";
                        };
                    };
                };
                servers = builtins.listToAttrs (map (name: {
                    inherit name;
                    value = {
                        enable = true;
                        # package = null;
                    };
                }) [
                    "bashls"
                    "cssls"
                    "gdscript"
                    "gopls"
                    "lua-ls"
                    "nil_ls"
                    "rust-analyzer"
                    "yamlls"
                ]);
            };
        };
    };
}

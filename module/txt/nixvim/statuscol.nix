{ config, lib, pkgs, ... }:

lib.mkSubmodule "nixvim" config {

    programs.nixvim = let
        diff = "║";
    in {

        plugins.gitsigns = {
            enable = true;
            settings = {
                signs = {
                    add.text = diff;
                    change.text = diff;
                    delete.text = diff;
                };
            };
        };

        keymaps = [
            {
                action = "<cmd>Gitsigns preview_hunk<cr>";
                key = "<leader>g";
                options.desc = "Hunk Hover";
            }
        ];

        extraConfigLuaPost = ''
            require("gitsigns").setup({
                _signs_staged_enable = true,
                _signs_staged = {

                    add = { text = "${diff}" },
                    change = { text = "${diff}" },
                    delete = { text = "${diff}" },
                },
            })
        '';

        extraPlugins = builtins.attrValues {
            inherit (pkgs.vimPlugins) statuscol-nvim;
        };

        extraConfigLua = ''
            vim.fn.sign_define("DiagnosticSignError", { text = "${config.icons.diagnostics.error}", texthl = "DiagnosticSignError" })
            vim.fn.sign_define("DiagnosticSignWarn", { text = "${config.icons.diagnostics.warn}", texthl = "DiagnosticSignWarn" })
            vim.fn.sign_define("DiagnosticSignInfo", { text = "${config.icons.diagnostics.info}", texthl = "DiagnosticSignInfo" })
            vim.fn.sign_define("DiagnosticSignHint", { text = "${config.icons.diagnostics.hint}", texthl = "DiagnosticSignHint" })

            require("statuscol").setup({
                relculright = true,
                setopt = true,
                segments = {
                    {
                        text = { require("statuscol.builtin").foldfun },
                        click = "v:lua.ScFa",
                    },
                    {
                        sign = {
                            name = { "Diagnostic" },
                            maxwidth = 1,
                            colwidth = 1,
                            auto = false,
                            click = "v:lua.ScSa",
                        },
                    },
                    {
                        text = { require("statuscol.builtin").lnumfunc },
                        maxwidth = 1,
                        colwidth = 1,

                        click = "v:lua.ScLa",
                    },
                    {
                        sign = {
                            name = { "GitSign" },
                            namespace = { "gitsign" },
                            maxwidth = 1,
                            colwidth = 1,
                            auto = false,
                            wrap = true,
                            fillchar = "│",

                        },
                        click = "v:lua.ScSa",
                    },
                },
            })
        '';
    };
}

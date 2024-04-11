{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins.telescope = {
            enable = true;
            extensions = {
                fzf-native.enable = true;
                undo.enable = true;
            };
            settings = {
                prompt_prefix = config.icons."search";
                selection_caret = "->";
            };
            keymaps = {
                "<leader>b" = {
                    action = "buffers";
                    options.desc = "Buffers";
                };
                "<leader>sa" = {
                    action = "autocommands";
                    options.desc = "AutoCmds";
                };
                "<leader>sc" = {
                    action = "commands";
                    options.desc = "Cmds";
                };
                "<leader>sf" = {
                    action = "live_grep";
                    options.desc = "Live Grep";
                };
                "<leader>sh" = {
                    action = "help_tags";
                    options.desc = "Help";
                };
                "<leader>sH" = {
                    action = "highlights";
                    options.desc = "Highlight Groups";
                };
                "<leader>d" = {
                    action = "diagnostics";
                    options.desc = "Diagnostics";
                };
                "<leader>sk" = {
                    action = "keymaps";
                    options.desc = "Keys";
                };
                "<leader>sm" = {
                    action = "marks";
                    options.desc = "Marks";
                };
                "<leader><leader>" = {
                    action = "find_files";
                    options.desc = "Files";
                };
                "<leader>so" = {
                    action = "vim_options";
                    options.desc = "Vim Options";
                };
            };
        };
        keymaps = [
            {
                key = "<leader>su";
                action = "<cmd>Telescope undo<cr>";
                options.desc = "Undo Tree";
            }
        ];
    };
}

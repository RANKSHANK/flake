{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins.telescope = {
            enable = true;
            extensions = {
                fzf-native.enable = true;
                undo.enable = true;
            };
            extraOptions = {
                prompt_prefix = config.icons."search";
                selection_caret = "->";
            };
            keymaps = {
                "<leader>b" = {
                    action = "buffers";
                    desc = "Buffers";
                };
                "<leader>sa" = {
                    action = "autocommands";
                    desc = "AutoCmds";
                };
                "<leader>sc" = {
                    action = "commands";
                    desc = "Cmds";
                };
                "<leader>sf" = {
                    action = "live_grep";
                    desc = "Live Grep";
                };
                "<leader>sh" = {
                    action = "help_tags";
                    desc = "Help";
                };
                "<leader>sH" = {
                    action = "highlights";
                    desc = "Highlight Groups";
                };
                "<leader>d" = {
                    action = "diagnostics";
                    desc = "Diagnostics";
                };
                "<leader>sk" = {
                    action = "keymaps";
                    desc = "Keys";
                };
                "<leader>sm" = {
                    action = "marks";
                    desc = "Marks";
                };
                "<leader><leader>" = {
                    action = "find_files";
                    desc = "Files";
                };
                "<leader>so" = {
                    action = "vim_options";
                    desc = "Vim Options";
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

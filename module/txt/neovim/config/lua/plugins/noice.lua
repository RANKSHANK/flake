return {
    "folke/noice.nvim",
    dir = require("lazy-nix-helper").get_plugin_path("noice.nvim"),
    event = "VeryLazy",
    dependencies = {
        { "MunifTanjim/nui.nvim" },
    },
    opts = {
    },
    keys = {
        {
            "<S-Enter>",
            function() require("noice").redirect(vim.fn.getcmdline()) end,
            mode = "c",
            desc = "Redirect Cmdline",
        },
        {
            "<leader>snl",
            function() require("noice").cmd("last") end,
            desc = "Noice Last Message",
        },
        {
            "<leader>snh",
            function() require("noice").cmd("history") end,
            desc = "Noice History",
        },
        {
            "<leader>sna",
            function() require("noice").cmd("all") end,
            desc = "Noice All",
        },
        {
            "<c-f>",
            function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
            silent = true,
            expr = true,
            desc = "Scroll forward",
            mode = { "i", "n", "s" },
        },
        {
            "<c-b>",
            function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
            silent = true,
            expr = true,
            desc = "Scroll backward",
            mode = { "i", "n", "s" },
        },
    },
    config = function()
        require("noice").setup({
            routes = {
                {
                    view = "notify",
                    filter = { event = "msg_showmode" },
                },
                {
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "written",
                    },
                },
                filter = {
                    event = "msg_show",
                    kind = "",
                },
                opts = { skip = true, },
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                progress = {
                    enabled = false,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
            },
            views = {
                cmd_line_popup = {
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    position = {
                        row = 5,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                    win_options = {
                        winhighlight = {
                            Normal = "Normal",
                            FloatBorder = "DiagnosticInfo",
                        },
                    },
                },
                lsp = {
                    progress = {
                        enabled = false,
                    },
                },
                messages = {
                    enabled = true;
                },
                notify = { "{title}" },
                popup_menu = {
                    relative = "editor",
                    position = {
                        row = 8,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = {
                            Normal = "Normal",
                            FloatBorder = "DiagnosticInfo",
                        },
                    },
                },
            },
        })
    end,
}

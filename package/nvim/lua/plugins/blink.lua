return {
    { "lspkind.nvim" },
    {
        "blink.cmp",
        event = "DeferredUIEnter",
        before = function()
            require("lz.n").trigger_load("lazydev.nvim")
            require("lz.n").trigger_load("lspkind.nvim")
        end,
        after = function()
            local winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel"
            require("blink.cmp").setup({
                signature = {
                    enable = true,
                    window = {
                        border = "single",
                    },
                },
                completion = {
                },
                sources = {
                    default = {
                        "lazydev",
                        "lsp",
                        "path",
                        "snippets",
                        "buffer",
                    },
                    providers = {
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            score_offset = 100,
                        },
                    },
                },
            })
        end,
    },
    {
        "lazydev.nvim",
        ft = "lua",
        after = function()
            require("lazydev").setup({
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" }, },
                    { path = "wezterm-types", mods = { "wezterm" }, },
                },
            })
        end,
    },
}

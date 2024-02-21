return {
    'VonHeikemen/lsp-zero.nvim',
    dir = require("lazy-nix-helper").get_plugin_path("lsp-zero.nvim"),
    branch = 'v1.x',
    dependencies = {
        {
            'neovim/nvim-lspconfig',
            dir = require("lazy-nix-helper").get_plugin_path("nvim-lspconfig"),
        },
        {
            'hrsh7th/nvim-cmp',
            dir = require("lazy-nix-helper").get_plugin_path("nvim-cmp"),
        },
        {
            'hrsh7th/cmp-nvim-lsp',
            dir = require("lazy-nix-helper").get_plugin_path("cmp-nvim-lsp"),
        },
        {
            'hrsh7th/cmp-buffer',
            dir = require("lazy-nix-helper").get_plugin_path("cmp-buffer"),
        },
        {
            'hrsh7th/cmp-path',
            dir = require("lazy-nix-helper").get_plugin_path("cmp-path"),
        },
        {
            'saadparwaiz1/cmp_luasnip',
            dir = require("lazy-nix-helper").get_plugin_path("cmp-luasnip"),
        },
        {
            'hrsh7th/cmp-nvim-lua',
            dir = require("lazy-nix-helper").get_plugin_path("cmp-nvim-lua"),
        },
        {
            'hrsh7th/cmp-nvim-lsp-signature-help',
            dir = require("lazy-nix-helper").get_plugin_path("nvm_lsp_signature_help"),
        },
        {
            'L3MON4D3/LuaSnip',
            dir = require("lazy-nix-helper").get_plugin_path("LuaSnip"),
        },
        {
            'rafamadriz/friendly-snippets',
            dir = require("lazy-nix-helper").get_plugin_path("freindly-snippets"),
        },
        {
            "nvimtools/none-ls.nvim",
            dir = require("lazy-nix-helper").get_plugin_path("none-ls"),
        },

    },
    opts = {
        sources = {
            { name = "path" },
            { name = "nvim_lsp"},
            { name = "buffer", keyword_length = 3},
            { name = "luasnip", keyword_length = 2},
        },
    },
    config = function()
        local lsp = require("lsp-zero").preset({
            name = "minimal",
            set_lsp_keymaps = false,
            manage_nvim_cmp = true,
            suggest_lsp_servers = false,
        })

        local conf = require("lspconfig")
        conf.clangd.setup({});
        conf.bashls.setup({});
        conf.lua_ls.setup({});
        conf.nil_ls.setup({});
        conf.jdtls.setup({});
        conf.pyright.setup({});
        conf.rust_analyzer.setup({});
        local cmp = require("cmp")
        cmp.setup({
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            preselect = cmp.PreselectMode.None,
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            window = {
                documentation = {
                    max_height = 15,
                    max_width =  80,
                    border = "rounded",
                },
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-N>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-P>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-b>"] = cmp.mapping.scroll_docs( -4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-c>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            formatting = {
                format = function(_, item)
                    local icons = require("lazyvim.config").icons.kinds
                    if icons[item.kind] then
                        item.kind = icons[item.kind] .. item.kind
                    end
                    return item
                end,
            },
            experimental = {
                ghost_text = {
                    hl_group = "LspCodeLens",
                },
            },
        })
        lsp.on_attach(function(_, buffnr)
            local function diagnostic_goto(next, severity)
                local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
                severity = severity and vim.diagnostic.severity[severity] or nil
                return function()
                    go({ severity = severity })
                end
            end
            require("which-key").register({
                buffer = buffnr,
                noremap = false,
                ["<leader>c"] = {
                    mode = {"n", "v"},
                    a = { vim.lsp.buf.code_action ,"Code Action", },
                    d = { vim.diagnostic.open_float,"Line Diagnostics"},
                    r = { vim.lsp.buf.rename,"Rename"},
                    l = { "<CMD>LspInfo<CR>","LSP Info"},
                },
                ["g"] = {
                    d = { vim.lsp.buf.definition,"Definition"},
                    r = { vim.lsp.buf.references,"References"},
                    D = { vim.lsp.buf.declaration,"Declaration"},
                    I = { vim.lsp.buf.implementation,"Implementations"},
                    t = { vim.lsp.buf.type_definition,"Type Definition"},
                    K = { vim.lsp.buf.signature_help,"Signature Help"},
                },
                ["<c-k>"] = { vim.lsp.buf.signature_help,"Signature Help"},
                ["K"] = { vim.lsp.buf.hover, "Hover"},
                ["]"] = {
                    d = { diagnostic_goto(true),"Next Diagnostic"},
                    e = { diagnostic_goto(true, "ERROR"),"Next Error"},
                    w = { diagnostic_goto(true, "WARN"),"Next Warning"},
                },
                ["["] = {
                    d = { diagnostic_goto(false),"Previous Diagnostic"},
                    e = { diagnostic_goto(false, "ERROR"),"Previous Error"},
                    w = { diagnostic_goto(false, "WARN"),"Previous Warning"},
                },
            })
        end)
        lsp.setup()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.diagnostics.eslint,
                null_ls.builtins.completion.spell,
            },
        })
        vim.diagnostic.config({
            update_in_insert = true,

            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
            }
        })

    end
}

return {
    {
        "none-ls.nvim",
    },
    {
        "nvim-lspconfig",
        lazy = false,
        before = function()
            require("lz.n").trigger_load("none-ls.nvim")
            require("lz.n").trigger_load("blink.cmp")
        end,
        after = function()
            local nonels = require("null-ls")

            local code_actions = nonels.builtins.code_actions
            local diagnostics = nonels.builtins.diagnostics
            local formatting = nonels.builtins.formatting
            local hover = nonels.builtins.hover
            local completion = nonels.builtins.completion

            local ls_sources = {
                formatting.sylua,
                formatting.nixfmt,
                diagnostics.statix,
                code_actions.statix,
                diagnostics.deadnix
            }

            nonels.setup({
                diagnostics_format = "[#{m}] #{s} (#{c})",
                debounce = 250,
                default_timeout = 5000,
                sources = ls_sources;
            })

            local lspconfig = require("lspconfig")
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            vim.diagnostic.config({
                float = { border = "single" };
                update_in_insert = true,
                virtual_text = false,
                virtual_lines = {
                    enable = true,
                    current_line = true
                },
                underline = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = vim.g.icons.diagnostics.error,
                        [vim.diagnostic.severity.WARN] = vim.g.icons.diagnostics.warn,
                        [vim.diagnostic.severity.INFO] = vim.g.icons.diagnostics.info,
                        [vim.diagnostic.severity.HINT] = vim.g.icons.diagnostics.hint,
                    },
                    linehl = {
                        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
                    },
                    numhl = {
                        [vim.diagnostic.severity.ERROR] = vim.g.icons.diagnostics.error,
                        [vim.diagnostic.severity.WARN] = vim.g.icons.diagnostics.warn,
                        [vim.diagnostic.severity.INFO] = vim.g.icons.diagnostics.info,
                        [vim.diagnostic.severity.HINT] = vim.g.icons.diagnostics.hint,
                    },
                },
            })

            lspconfig.nil_ls.setup({
                capabilities = capabilities,
                cmd = { "nil" },
                settings = {
                    [ "nil" ] = {
                        nix = {
                            binary = "nix",
                            maxMemoryMB = nil,
                            flake = {
                                autoEvalInputs = false, -- Fullscreen errors? no.
                                autoArchive = false,
                                nixpkgsInputName = nil,
                            },
                        },
                        formatting = {
                            command = { "nixfmt", "quiet" },
                        },
                    },
                },
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarrc.jsonc") then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                        format = {
                            enable = true,
                        },
                        runtime = {
                            version = "LuaJIT",
                        },
                        telemetry = {
                            enable = false,
                        },
                        workspace = {
                            checkThirdParty = false,
                        },
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = {
                            disable = {
                                "missing-fields",
                            },
                        },
                    })
                end,
                settings = {
                    Lua = {},
                },
            })

            lspconfig.ccls.setup({
                capabilities = capabilities,
                cmd = {
                    "ccls",
                },
            })

            lspconfig.jsonls.setup({
                capabilities = capabilities
            })
        end,
    },
    {
        binds = {
            {
                mode = "n",
                {
                    "<leader>l",
                    desc = "LSP  "
                },
                {
                    "<leader>lg",
                    desc = "Decl/Def"
                },
                {
                    "<leader>lw",
                    desc = "WorkSpace"
                },
            },
        },
    },
}

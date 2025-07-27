return {
  {
    "blink.cmp",
    event = "DeferredUIEnter",
    before = function()
      local ld = require("lz.n").trigger_load
      ld("lazydev.nvim")
      ld("lspkind.nvim")
      ld("blink-cmp-spell")
    end,
    after = function()
      local winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel"
      require("blink-cmp").setup({
        signature = {
          enabled = true,
          window = {
            border = "single",
          },
        },
        completion = {
          ghost_text = {
            enabled = true,
          },
          menu = {},
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 300,
            window = {
              border = "single",
            },
          },
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
    binds = {
      {
        "<C-space>",
        function()
          require("blink-cmp").show()
        end,
      },
    },
  },
  {
    "lazydev.nvim",
    ft = "lua",
    after = function()
      require("lazydev").setup({
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "wezterm-types", mods = { "wezterm" } },
        },
      })
    end,
  },
  {
    "nvim-autopairs",
    event = "InsertEnter",
    after = function()
      require("nvim-autopairs").setup({})
    end,
  },
}

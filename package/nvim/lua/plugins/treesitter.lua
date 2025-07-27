local highlight = {
  "RainbowDelimiterRed",
  "RainbowDelimiterYellow",
  "RainbowDelimiterBlue",
  "RainbowDelimiterOrange",
  "RainbowDelimiterGreen",
  "RainbowDelimiterViolet",
  "RainbowDelimiterCyan",
}
return {
  {
    "nvim-treesitter",
    after = function()
      require("nvim-treesitter.configs").setup({
        modules = {},
        sync_install = false,
        ignore_install = {},
        ensure_installed = {},
        auto_install = false,
        indent = {
          enable = true,
        },
        context_commentstring = {
          enable = true,
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
  {
    "rainbow-delimiters.nvim",
    after = function()
      vim.g.rainbow_delimiters = {
        highlight = highlight,
      }
    end,
  },
  {
    "indent-blankline.nvim",
    event = "DeferredUIEnter",
    before = function()
      require("lz.n").trigger_load("nvim-treesitter")
      require("lz.n").trigger_load("rainbow-delimiters.nvim")
    end,
    after = function()
      local hooks = require("ibl.hooks")

      require("ibl").setup({
        scope = {
          enabled = true,
          show_start = true,
          show_end = true,
          injected_languages = true,
          highlight = highlight,
          char = "󰇙",
        },
        indent = {
          char = "",
          highlight = highlight,
        },
      })

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "nvim-treesitter-context",
    event = "DeferredUIEnter",
    before = function()
      require("lz.n").trigger_load("nvim-treesitter")
    end,
    after = function()
      require("treesitter-context").setup({
        enable = true,
        muliwindow = false,
        max_lines = 8,
        min_window_height = 16,
        line_numbers = true,
        mode = "cursor",
      })
    end,
  },
  {
    "nvim-treesitter-textobjects",
    event = "DeferredUIEnter",
    before = function()
      require("lz.n").trigger_load("nvim-treesitter")
    end,
    after = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {},
      })
    end,
    binds = {},
  },
}

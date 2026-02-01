vim.g._ts_force_sync_parsing = true
vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.treesitter.language._complete(),
  group = vim.api.nvim_create_augroup("LoadTreesitter", {}),
  callback = function()
    vim.treesitter.start()
  end,
})
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
    binds = {},
  },
  {
    "hlargs",
    event = "DeferredUIEnter",
    aftres = function ()
      require("hlargs").setup({
      })
    end
  },
  {
    "helpview.nvim",
    lazy = false,
    after = function ()
      require("helpview").setup({
      })
    end
  },
  {
    "nvim-treesitter-endwise",
  },
}

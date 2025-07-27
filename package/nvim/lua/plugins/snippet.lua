return {
  {
    "friendly-snippets",
  },
  {
    "LuaSnip",
    before = function()
      require("lz.n").trigger_load("friendly-snippets")
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
    after = function()
      require("luasnip").setup({
        history = true,
        delete_check_events = "TextChanged",
        keys = function()
          return {}
        end,
      })
    end,
    -- stylua: ignore
  },
  {
    "tabout.nvim",
    event = "InsertCharPre",
    before = function()
      local ld = require("lz.n").trigger_load
      ld("nvim-treesitter")
      ld("luasnip")
      ld("blink.cmp")
    end,
    after = function()
      require("tabout").setup({
        tabkey = "<Tab>",
        backwards_tabkey = "<S-Tab>",
        act_as_tab = true,
        act_as_shift_tab = false,
        default_tab = "<C-Tab>",
        default_backwards_tab = "<SC-Tab>",
        enable_backwarrds = true,
        completion = false,
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true,
        exclude = {},
      })
    end,
  },
}

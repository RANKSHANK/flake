return {
  {
    "nui.nvim",
  },
  {
    "nvim-notify",
  },
  {
    "noice.nvim",
    event = "DeferredUIEnter",
    before = function()
      require("lz.n").trigger_load("nui.nvim")
      require("lz.n").trigger_load("nvim-notify")
    end,
    after = function()
      require("noice").setup({
        routes = {
          {
            filter = {
              event = "msg_show",
              find = "",
            },
            opts = {
              skip = true,
            },
          },
        },
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
          },
        },
        presets = {
          command_palette = true,
          lsp_doc_border = true,
        },
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = " ", lang = "bash" },
          run = { pattern = "^:r*!", icon = " ", lang = "bash" },
          lua = { pattern = "^:%s*lua%s+", icon = " ", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = " " },
          input = {},
        },
        popupmenu = {
          enabled = true,
          backend = "nui",
        },
        views = {
          cmdline_popup = {
            position = {
              row = 8,
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
          },
          popupmenu = {
            relative = "editor",
            position = {
              row = 11,
              col = "50%",
            },
            size = {
              width = 60,
              height = 10,
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
  },
}

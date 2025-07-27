return {
  "lualine.nvim",
  event = "DeferredUIEnter",
  before = function()
    require("lz.n").trigger_load("nvim-web-devicons")
  end,
  after = function()
    require("lualine").setup({
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = {
          tabline = {
            "oil",
          },
          winbar = {
            "oil",
          },
        },
      },
      tabline = {},
      inactive_winbar = {},
      sections = {},
      inactive_sections = {},
      winbar = {
        lualine_a = {
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = {
              left = 1,
              right = 0,
            },
          },
          {
            "filename",
            path = 1,
            {
              "filename",
              path = 1,
              symbols = vim.g.icons.file_status,
            },
          },
        },
        lualine_b = {
          {
            "diagnostics",
            symbols = vim.g.icons.diagnostics,
          },
        },
        lualine_x = {
          "branch",
          {
            "diff",
            symbols = vim.g.icons.git,
          },
        },
        lualine_y = {},
        lualine_z = {
          { "progress", separator = "", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
      },
      extensions = { "oil" },
    })
  end,
}

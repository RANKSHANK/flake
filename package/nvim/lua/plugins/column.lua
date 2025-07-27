return {
  {
    "statuscol.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("statuscol").setup({
        setopt = true,
        segments = {
          {
            sign = {
              name = { ".*" },
              text = { ".*" },
            },
            click = "v:lua.ScSa",
          },
          {
            text = { require("statuscol.builtin").lnumfunc },
            click = "v:lua.scFa",
          },
          {
            sign = {
              namespace = { "gitsign" },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
              wrap = true,
              fillchar = "│",
            },
            click = "gitsigns",
          },
          {
            text = {
              function(args)
                args.fold.close = ""
                args.fold.open = ""
                args.fold.sep = " "
                return require("statuscol.builtin").foldfunc(args)
              end,
            },
            click = "v:lua.ScFa",
          },
        },
      })
    end,
  },
  {
    "gitsigns.nvim",
    event = "DeferredUIEnter",
    before = function()
      require("lz.n").trigger_load("statuscol")
    end,
    after = function()
      local diff = "║"
      local signs = {
        add = { text = diff },
        change = { text = diff },
        delete = { text = diff },
      }
      require("gitsigns").setup({
        signs_staged = signs,
        signs = signs,
      })
    end,
    binds = {
      {
        "<leader>gk",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Preview git hunk",
        mode = { "n" },
      },
    },
  },
  {
    "modicator.nvim",
    event = "DeferredUIEnter",
    before = function()
      require("lz.n").trigger_load("lualine")
    end,
    after = function()
      require("modicator").setup({
        show_warnings = true,
        use_cursorline_background = true,
        integration = {
          lualine = {
            mode_section = "a",
          },
        },
      })
    end,
  },
  {
    "smartcolumn.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("smartcolumn").setup({
        scope = "window",
        disabled_filetypes = {
          "help",
          "text",
          "markdown",
          "mason",
          "nvim",
          "dashboard",
          "lazy",
          "alpha",
          "neo-tree",
        },
      })
    end,
  },
}

local theme = require("telescope.themes").get_ivy({
  layout_config = {
    preview_cutoff = 1,
    width = function(_, max_columns, _)
      return math.min(math.floor(max_columns * 0.8), 120)
    end,
    height = function(_, _, max_lines)
      return math.min(math.floor(max_lines * 0.6), 20)
    end,
  },
})
return {
  {
    "telescope-fzf-native.nvim",
  },
  {
    "telescope.nvim",
    cmd = "Telescope",
    before = function()
      require("lz.n").trigger_load("nvim-lua/plenary.nvim")
      require("lz.n").trigger_load("telescope-undo.nvim")
    end,
    binds = {
      mode = { "n", "x", "o" },
      {
        "<leader><leader>",
        icon = "󰱼 ",
        desc = "Telescope Files",
        function()
          require("telescope.builtin").find_files(theme)
        end,
      },
      {
        "<leader>tf",
        desc = "Telescope GREP",
        function()
          require("telescope.builtin").live_grep(theme)
        end,
      },
      {
        "<leader>tb",
        desc = "Telescope Buffers",
        function()
          require("telescope.builtin").buffers(theme)
        end,
      },
      {
        "<leader>th",
        desc = "Telescope Highlight Groups",
        function()
          require("telescope.builtin").highlights(theme)
        end,
      },
      {
        "<leader>t?",
        desc = "Telescope Help Tags",
        function()
          require("telescope.builtin").help_tags(theme)
        end,
      },
      {
        "<leader>ta",
        desc = "Telescope Auto Commands",
        function()
          require("telescope.builtin").autocommands(theme)
        end,
      },
      {
        "<leader>tc",
        desc = "Telescope HighlightGroups",
        function()
          require("telescope.builtin").command_history(theme)
        end,
      },
      {
        "<leader>td",
        desc = "Telescope Diagnostics",
        function()
          require("telescope.builtin").diagnostics(theme)
        end,
      },
      {
        "<leader>tu",
        desc = "Telescope Undo History",
        function()
          require("telescope").extensions.undo.undo(theme)
        end,
      },
    },
    after = function()
      local tele = require("telescope")
      tele.load_extension("fzf")
      tele.load_extension("undo")
      tele.setup({
        defaults = {
          pickers = {
            theme = "ivy",
          },
        },
        extensions = {
          undo = {
            use_delta = true,
            side_by_side = true,
          },
        },
      })
    end,
  },
}

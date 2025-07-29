return {
  {
    "telescope-fzf-native.nvim",
  },
  {
    "telescope.nvim",
    cmd = "Telescope",
    before = function()
      require("lz.n").trigger_load("nvim-lua/plenary.nvim")
    end,
    binds = {
      mode = { "n", "x", "o" },
      {
        "<leader><leader>",
        icon = "󰱼 ",
        desc = "Telescope Files",
        function()
          require("telescope.builtin").find_files()
        end,
      },
      {
        "<leader>tf",
        desc = "Telescope GREP",
        function()
          require("telescope.builtin").live_grep()
        end,
      },
      {
        "<leader>tb",
        desc = "Telescope Buffers",
        function()
          require("telescope.builtin").buffers()
        end,
      },
      {
        "<>",
      },
    },
    after = function()
      local tele = require("telescope")
      tele.load_extension("fzf")
      tele.setup({
        defaults = vim.tbl_extend(
          "force",
          tele.themes.get_ivy({
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
        ),
      })
    end,
  },
}

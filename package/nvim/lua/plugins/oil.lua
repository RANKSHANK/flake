return {
  "oil.nvim",
  lazy = false,
  binds = {
    {
      "-",
      mode = { "n", "x", "o" },
      desc = "Open File Explorer",
      function()
        require("oil").open()
      end,
    },
  },
  after = function()
    require("oil").setup({
      delete_to_trash = true,
      columns = {
        "icon",
        "size",
      },
      float = {
        win_options = {
          winblend = 0,
        },
        max_width = 80,
      },
    })
  end,
}

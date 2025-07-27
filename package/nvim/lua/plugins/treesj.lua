return {
  "treesj",
  before = function()
    require("treesj").setup({
      max_join_length = 1024,
      use_default_keymaps = false,
    })
  end,
  binds = {
    {
      "<leader>cs",
      function()
        require("treesj").toggle({
          split = {
            recursive = true,
          },
        })
      end,
      mode = { "n" },
      desc = "Split/Join",
    },
  },
}

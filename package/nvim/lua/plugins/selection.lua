return {
  {
    "vim-repeat",
  },
  {
    "leap.nvim",
    lazy = false,
    binds = {
      {
        "gs",
        mode = { "n", "x", "o" },
        desc = "Leap Remote",
        function()
          require("leap.remote").action()
        end,
      },
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("leap").action()
        end,
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("leap-from-window").action()
        end,
      },
    },
    before = function()
      require("lz.n").trigger_load("vim-repeat")
    end,
  },
  {
    "vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    after = function()
      require("illuminate").configure({
        delay = 200,
      })
    end,
    binds = {
      {
        "]]",
        function()
          require("illuminate").goto_next_reference(false)
        end,
        desc = "Next Reference",
      },
      {
        "[[",
        function()
          require("illuminate").goto_prev_reference(false)
        end,
        desc = "Prev Reference",
      },
    },
  },
  {
    "nvim-surround",
    after = function()
      require("nvim-surround").setup({})
    end,
  },
}

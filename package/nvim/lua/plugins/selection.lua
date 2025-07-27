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
    },
    before = function()
      require("lz.n").trigger_load("vim-repeat")
    end,
    after = function()
      require("leap").set_default_mappings()
    end,
  },
  {
    "flit.nvim",
    before = function()
      require("lz.n").trigger_load("leap")
    end,
    after = function()
      require("flit").setup({
        labeled_modes = "nx",
      })
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

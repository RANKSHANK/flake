local harpoon = require("harpoon")
return {
  "harpoon",
  before = function()
    require("lz.n").trigger_load("plenary")
  end,
  after = function()
    harpoon:setup({
      settings = {
        save_on_toggle = true,
      },
    })
    local ext = require("harpoon.extensions")
    harpoon:extend(ext.builtins.highligh_current_file())
  end,
  binds = {
    {
      "<leader>h",
      desc = "Harpoon",
      icon = "󱡅",
    },
    {
      "<leader>hu",
      function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "UI",
    },
    {
      "<leader>ha",
      function()
        harpoon:list():add()
      end,
      desc = "Add File",
    },
    {
      "<leader>h1",
      function()
        harpoon:list():select(1)
      end,
      desc = "Goto 1",
    },
    {
      "<leader>h2",
      function()
        harpoon:list():select(2)
      end,
      desc = "Goto 2",
    },
    {
      "<leader>h3",
      function()
        harpoon:list():select(3)
      end,
      desc = "Goto 3",
    },
    {
      "<leader>h4",
      function()
        harpoon:list():select(4)
      end,
      desc = "Goto 4",
    },
    {
      "<leader>h5",
      function()
        harpoon:list():select(5)
      end,
      desc = "Goto 5",
    },
    {
      "<leader>h6",
      function()
        harpoon:list():select(6)
      end,
      desc = "Goto 6",
    },
    {
      "<leader>h7",
      function()
        harpoon:list():select(7)
      end,
      desc = "Goto 7",
    },
    {
      "<leader>h8",
      function()
        harpoon:list():select(8)
      end,
      desc = "Goto 8",
    },
    {
      "<leader>h9",
      function()
        harpoon:list():select(9)
      end,
      desc = "Goto 9",
    },
    {
      "<leader>h0",
      function()
        harpoon:list():select(0)
      end,
      desc = "Goto 0",
    },
  },
}

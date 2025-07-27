require("which-key").setup({})
require("which-key").add({
  {
    mode = { "n", "i" },
    { "<C-BS>", "<C-\\><C-o>db", { noremap = true, desc = "Delete word", silent = true } },
  },
  {
    "<leader>g",
    icon = " ",
    desc = "git",
  },
  {
    "<leader>c",
    icon = "󰘦 ",
    desc = "Code Actions",
  },
  {
    "<leader>t",
    icon = " ",
    desc = "Search",
  },
  {
    "<leader>s",
    icon = "",
    desc = "Select",
  },
  {
    "<leader>c",
    icon = "⚡",
    desc = "Code",
  },
  {
    "<leader>d",
    icon = "󰃤 ",
    desc = "Debug",
  },
  {
    "<leader>g",
    icon = "󰴠 ",
    desc = "Goto",
  },
})

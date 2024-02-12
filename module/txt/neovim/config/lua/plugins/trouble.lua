return {
  "folke/trouble.nvim",
  dir = require("lazy-nix-helper").get_plugin_path("trouble.nvim"),
  cmd = {
    "TroubleToggle",
    "Trouble"
  },
  opts = {
    use_diagnostic_signs = true
  },
  keys = {
    { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
    { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
  },
}

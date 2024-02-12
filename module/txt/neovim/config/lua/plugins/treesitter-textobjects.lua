return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dir = require("lazy-nix-helper").get_plugin_path("nvim-treesitter-textobjects"),
  init = function()
    require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
  end,
}

return {
  "folke/neodev.nvim",
  dir = require("lazy-nix-helper").get_plugin_path("neodev-nvim"),
  opts = {
    experimental = {
      pathStrict = true,
    }
  },
}

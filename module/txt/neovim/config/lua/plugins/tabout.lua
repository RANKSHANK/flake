return {
  "abecodes/tabout.nvim",
  dir = require("lazy-nix-helper").get_plugin_path("tabout.nvim"),
  config = function ()
    require("tabout").setup({
    })
  end
}

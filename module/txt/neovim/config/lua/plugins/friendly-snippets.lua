return {
  "rafamadriz/friendly-snippets",
  dir = require("lazy-nix-helper").get_plugin_path("friendly-snippets"),
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}

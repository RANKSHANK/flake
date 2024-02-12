return {
  "ggandor/flit.nvim",
  dir = require("lazy-nix-helper").get_plugin_path("flit.nvim"),
  dependencies = {
    "ggandor/leap.nvim",
  },
  keys = function()
    local ret = {}
    for _, key in ipairs({ "f", "F", "t", "T" }) do
      ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
    end
    return ret
  end,
  opts = { labeled_modes = "nx" },
}

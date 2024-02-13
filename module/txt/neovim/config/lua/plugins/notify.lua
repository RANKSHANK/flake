return {
    "rcarriga/nvim-notify",
    dir = require("lazy-nix-helper").get_plugin_path("notify"),
    opts = {
        render = "wrapped-compact",
        max_width = 40,
    },
}

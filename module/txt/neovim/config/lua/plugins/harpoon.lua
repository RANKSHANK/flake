return {
    "ThePrimeagen/harpoon2",
    dir = require("lazy-nix-helper").get_plugin_path("harpoon2"),
    lazy = true,
    keys = {
        { "<leader>uh", function () require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon UI" },
        { "<leader>mu", function () require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon UI" },
        { "<leader>ma", function () require("harpoon.mark").add_file() end, desc = "Harpoon Add File" },
        { "<leader>m1", function () require("harpoon.ui").nav_file(1) end,desc = "Harpoon File 1" },
        { "<leader>m2", function () require("harpoon.ui").nav_file(2) end,desc = "Harpoon File 2" },
        { "<leader>m3", function () require("harpoon.ui").nav_file(3) end,desc = "Harpoon File 3" },
        { "<leader>m4", function () require("harpoon.ui").nav_file(4) end,desc = "Harpoon File 4" },
    },
    opts = {
        global_settings = {
            mark_branch = true,
        },
        projects = {
        }
    }
}

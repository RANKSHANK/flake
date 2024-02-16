return {
    "nvim-neorg/neorg",
    dir = require("lazy-nix-helper").get_plugin_path("neorg"),
    dependencies = {
        { "nvim-lua/plenary.nvim", },
        {
            "nvim-neorg/neorg-telescope",
            dir = require("lazy-nix-helper").get_plugin_path("neorg-telescope"),
        },
    },
    config = function() require("neorg").setup({
        load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {},
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        uni = "$XDG_DOCUMENTS_DIR/uni",
                    },
                },
            },
            ["core.integrations.telescope"] = {},
        },
    }) end,
    keys = {
        {
            "<leader>n",
            "Telescope neorg find_backlinks",
            "Telescope Neorg Backlinks",
        },
    },
}

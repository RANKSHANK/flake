return {
    "nvim-neorg/neorg",
    dir = require("lazy-nix-helper").get_plugin_path("neorg"),
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim", },
        {
            "nvim-neorg/neorg-telescope",
            dir = require("lazy-nix-helper").get_plugin_path("neorg-telescope"),
        },
    },
    config = function()
        local norg = require("neorg")
        norg.setup({
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {},
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "$XDG_DOCUMENTS_DIR/notes",
                        },
                    },
                    ["core.integrations.telescope"] = {},
                },
                ["core.ui.calendar"] = {},
                ["core.summary"] = {},
            }
        })
    end,
    build = ":Neorg sync-parsers",
}

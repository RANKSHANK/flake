return {
    "stevearc/oil.nvim",
    dir = require("lazy-nix-helper").get_plugin_path("oil"),
    lazy = false,
    keys = {
        {
            "<leader>e",
            mode = { "n", "x", "o" },
            desc = "Open File Explorer",
            "<cmd>lua require(\"oil\").open()<cr>"},
        },
    config = function()
        require("oil").setup({
            delete_to_trash = true,
            columns = {
                "icon",
                "size",
            },
            float = {
                win_options = {
                    winblend = 0,
                },
                max_width = 80,
            },
        })
    end,
}

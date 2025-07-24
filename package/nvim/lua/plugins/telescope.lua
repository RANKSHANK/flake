return {
    "telescope.nvim",
    cmd = "Telescope",

    before = function()
        require("lz.n").trigger_load("nvim-lua/plenary.nvim")
    end,
    after = function()
        require("telescope").setup()
    end,
    binds = {
        {
            "<leader><leader>",
            mode = { "n", "x", "o" },
            desc = "Search File Names",
            function()
                require("telescope.builtin").find_files()
            end
        },
        {
            "<leader>sf",
            mode = { "n", "x", "o" },
            desc = "GREP Contents",
            function()
                require("telescope.builtin").live_grep()
            end
        },
    },

}

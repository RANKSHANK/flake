return {
    "RANKSHANK/shelllsp.nvim",
    dir = "/home/rankshank/project/shelllsp.nvim",
    dependencies = {
    { 
        "neovim/nvim-lspconfig",
        dir = require("lazy-nix-helper").get_plugin_path("nvim-lspconfig"),
    },
    },
--    dev = true,
    lazy = false,
    config = function()
        require("shelllsp").setup({})
    end,
}

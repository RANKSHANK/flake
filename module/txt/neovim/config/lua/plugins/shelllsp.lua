return {
    "RANKSHANK/shelllsp.nvim",
    dir = "/home/rankshank/project/shelllsp.nvim",
    dependencies = {
    {
        dir = require("lazy-nix-helper").get_plugin_path("nvim-lspconfig"),
    },
    },
    lazy = false,
    config = function()
        require("shelllsp").setup({})
    end,
}

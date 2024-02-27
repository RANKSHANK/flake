return {
    "RANKSHANK/shelllsp.nvim",
    dir = "/home/rankshank/projects/shelllsp.nvim",
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

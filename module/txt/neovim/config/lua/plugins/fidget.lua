return {
	"j-hui/fidget.nvim",
    dir = require("lazy-nix-helper").get_plugin_path("fidget.nvim"),
	dependencies = {
        "neovim/nvim-lspconfig",
        dir = require("lazy-nix-helper").get_plugin_path("nvim-lspconfig"),
    },
	event = "LspAttach",
	config = function()
		require("fidget").setup({
            notification = {
                override_vim_notify = false;
            }
        })
	end,
}

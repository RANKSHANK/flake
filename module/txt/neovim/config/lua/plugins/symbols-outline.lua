return {
	"simrat39/symbols-outline.nvim",
    dir = require("lazy-nix-helper").get_plugin_path("symbols-outline"),
	lazy = true,
	keys = {
		{ "<leader>co", "<CMD>SymbolsOutline<CR>", desc = "Code Outline" },
	},
	config = function()
		require("symbols-outline").setup({})
	end,
}

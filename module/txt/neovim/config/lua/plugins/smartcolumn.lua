return {
		"m4xshen/smartcolumn.nvim",
		dir = require("lazy-nix-helper").get_plugin_path("smartcolumn.nvim"),
		opts = {
				scope = "window",
				disabled_filetypes = {
						"help",
						"text",
						"markdown",
						"mason",
						"nvim",
						"dashboard",
						"lazy",
						"alpha",
						"neo-tree",
				}
		}
}

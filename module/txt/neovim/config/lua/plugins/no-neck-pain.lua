return {
	"shortcuts/no-neck-pain.nvim",
    dir = require("lazy-nix-helper").get_plugin_path("no-neck-pain.nvim"),
	lazy = false,
	keys = {
		{ "<leader>uc", "<CMD>NoNeckPain<CR>", desc = "Toggle Centered Editor" },
	},
	opts = {
        width = 80,
		buffers = {
			wo = {
				fillchars = "eob: ",
			},
			colors = {
				blend = -0.3;
			},
		},
        autocmds = {
            -- enableOnVimEnter = true,
        },
    },
}

return {
	"nvim-treesitter/nvim-treesitter",
    dir = require("lazy-nix-helper").get_plugin_path("nvim-treesitter"),
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{ "<c-space>", desc = "Increment selection" },
		{ "<bs>", desc = "Shrink selection", mode = "x" },
		{ "<leader>pf", require("telescope").find_files, desc = "Find Project Files" },
	},
	opts = {
		highlight = {
            enable = true,
        },
		indent = {
            enable = true,
        },
		context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
		ensure_installed = {},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = "<nop>",
				node_decremental = "<bs>",
			},
		},
	},
	config = function(_, opts)
		local configs = require("nvim-treesitter.configs")

	end,
}

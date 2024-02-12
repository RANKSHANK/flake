return {
	"folke/which-key.nvim",
    dir = require("lazy-nix-helper").get_plugin_path("which-key.nvim"),
	dependencies = "LazyVim/Lazyvim",
	opts = {
		plugins = { spelling = true },
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		local keymaps = {
			mode = { "n", "v" },
			["g"] = { name = "+goto" },
			["gz"] = { name = "+surround" },
			["]"] = { name = "+next" },
			["["] = { name = "+prev" },
			["<leader>c"] = { name = "+code" },
			["<leader>d"] = { name = "+debug" },
			["<leader>f"] = { name = "+file/find" },
			["<leader>g"] = { name = "+git" },
			["<leader>gh"] = { name = "+hunks" },
			["<leader>s"] = {
                name = "+search" },
			["<leader>t"] = { name = "+todo" },
			["<leader>u"] = {
                name = "+ui",
                mode = {"n", "v"},
                l = { "<CMD>Lazy<CR>", "Lazy", },
            },
			["<leader>w"] = { name = "+window" },
			["<leader>x"] = { name = "+diagnostics/quickfix" },
		}
		keymaps["<leader>sn"] = { name = "+noice" }
		wk.register(keymaps)
	end,
}

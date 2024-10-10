return {
	"nvim-telescope/telescope.nvim",
    dir = require("lazy-nix-helper").get_plugin_path("telescope.nvim"),
	dependencies = {
        {
            "nvim-lua/plenary.nvim",
            dir = require("lazy-nix-helper").get_plugin_path("plenary.nvim"),
        },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            dir = require("lazy-nix-helper").get_plugin_path("telescope-fzf-native.nvim"),
        },
        {
            "debugloop/telescope-undo.nvim",
            dir = require("lazy-nix-helper").get_plugin_path("telescope-undo.nvim"),
        },
	},
	cmd = "Telescope",
	version = false,
	keys = {
		{ "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
		{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
		{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
		{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
		{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
		{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
		{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
		{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
		{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
		{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
		{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
		{ "<leader>su", "<CMD>Telescope undo<CR>", desc = "Undo Tree" },
		{ "<leader>sf", "<CMD>Telescope live_grep<CR>", desc = "Live Grep" },
        { "<leader><leader>", "<CMD>Telescope find_files<CR>", desc = "Find File" },
	},
	opts = {
	},
	config = function()
		require("telescope").load_extension("undo")
		require("telescope").load_extension("fzf")
		require("telescope").setup({
		defaults = vim.tbl_extend( "force", require("telescope.themes").get_ivy({
            layout_config = {
               preview_cutoff = 1,
               width = function(_, max_columns, _)
                   return math.min(math.floor(max_columns * 0.8), 120)
                end,
                height = function(_, _, max_lines)
                    return math.min(math.floor(max_lines * 0.6), 20)
                end,
            },
        }), {
			mappings = {
				i = {
					["<c-t>"] = function(...)
						return require("trouble.providers.telescope").open_with_trouble(...)
					end,
					["<C-Down>"] = function(...)
						return require("telescope.actions").cycle_history_next(...)
					end,
					["<C-Up>"] = function(...)
						return require("telescope.actions").cycle_history_prev(...)
					end,
					["<C-f>"] = function(...)
						return require("telescope.actions").preview_scrolling_down(...)
					end,
					["<C-b>"] = function(...)
						return require("telescope.actions").preview_scrolling_up(...)
					end,
				},
				n = {
					["q"] = function(...)
						return require("telescope.actions").close(...)
					end,
				},
			},
		}),
			extensions = {
				undo = {
					side_by_side = true,
					mappings = {
						i = {
							["<CR>"] = require("telescope-undo.actions").yank_additions,
							["<S-CR>"] = require("telescope-undo.actions").yank_deletions,
							["<C-CR>"] = require("telescope-undo.actions").restore,
						},
					},
				},
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                },
			},
		})
	end,
}

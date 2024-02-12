return {
	"mfussenegger/nvim-dap",
    dir = require("lazy-nix-helper").get_plugin_path("nvim-dap"),
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			config = function()
				require("dapui").setup()
			end,
		},
		{
			"jbyuki/one-small-step-for-vimkind",
		},
	},
	keys = {
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Breakpoint",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Continue",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
		},
		{
			"<leader>do",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.open()
			end,
			desc = "Repl Inspection",
		},
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "UI",
		},
		{
			"<leader>dw",
			function()
				require("dapui.widgets").hover()
			end,
			desc = "Widgets",
		},
		{
			"<leader>dl",
			function()
				require("osv").launch({ prot = 8086 })
			end,
			desc = "Lanch Lua Debugger Server",
		},
		{
			"<leader>dd",
			function()
				require("osv").launch({ prot = 8086 })
			end,
			desc = "Lanch Lua Debugger",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dap.configurations.lua = {
			{
				type = "nlua",
				request = "attach",
				name = "Attach to running Neovim instance",
			},
		}

		dap.adapters.nlua = function(callback, config)
			callback({
				type = "server",
				host = config.host or "127.0.0.1",
				port = config.port or 8086,
			})
		end

		dap.listeners.after.event_initialized["dapui.config"] = function()
			dapui.open({})
		end

		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close({})
		end

		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close({})
		end
	end,
}

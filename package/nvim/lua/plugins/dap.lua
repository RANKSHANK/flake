return {
  {
    "nvim-dap-virtual-text",
  },
  {
    "one-small-step-for-vimkind",
    ft = {
      "lua",
    },
  },
  {
    "nvim-dap",
    binds = {
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
    after = function()
      local dap = require("dap")

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

      require("nvim-dap-virtual-text").setup({
        enabled = true,
        virt_text_pos = "inline",
      })
    end,
  },
}

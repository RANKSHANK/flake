return {
  {
    "bufdel.nvim"
  },
  {
    "lualine.nvim",
    event = "DeferredUIEnter",
    before = function()
      require("lz.n").trigger_load("nvim-web-devicons")
      require("lz.n").trigger_load("bufdel.nvim")
    end,
    after = function()
      require("bufferline").setup({
        options = {
          close_command = function (bufnum)
            require("bufdel").delete(bufnum)
          end,
          right_mouse_command = "verical sbuffer %d",
          buffer_close_icon = "󰛉",
          modified_icon = "",
          close_icon = "󱎘",
          left_trunc_marker = "",
          right_trunc_marker = "",
          separator_style = "sloped",
          max_name_length = 20,
          max_prefix_length = 17,
          tab_size = 20,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          sort_by = "directory",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function (_, _, diagnostics_dict, _)
            local s = ""
            for e, n in pairs (diagnostics_dict) do
              local sym = e == "error" and vim.g.icons.error or (e == "warning" and vim.g.icons.warning or "")
              if sym ~= "" then
                s = s .. " " .. n .. sym
              end
            end
          end,
          numbers = function(opts)
            return string.format("%s.%s", opts.raise(opts.id), opts.lower(opts.ordinal))
          end,
        }
      })
    end,
  },
}

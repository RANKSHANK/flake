return {
  {
    "none-ls.nvim",
  },
  {
    "nvim-lspconfig",
    lazy = false,
    before = function()
      require("lz.n").trigger_load("none-ls.nvim")
      require("lz.n").trigger_load("blink.cmp")
    end,
    binds = {
      {
        {
          "<leader>gd",
          function()
            vim.lsp.buf.definition()
          end,
          desc = "Goto Definition",
        },
        {
          "<leader>gr",
          function()
            vim.lsp.buf.references()
          end,
          desc = "Goto References",
        },
        {
          "<leader>gi",
          function()
            vim.lsp.buf.implementation()
          end,
          desc = "Goto Implementations",
        },
        {
          "<leader>gt",
          function()
            vim.lsp.buf.type_definition()
          end,
          desc = "Goto Implementations",
        },
        {
          "<leader>ca",
          function()
            vim.lsb.buf.code_action()
          end,
          desc = "Actions",
        },
        {
          "<leader>cd",
          function()
            vim.diagnostic.open_float()
          end,
          desc = "Diagnostic Info",
        },
        {
          "<leader>cr",
          function()
            vim.lsp.buf.rename()
          end,
          desc = "Rename",
        },
      },
    },
    after = function()
      local nonels = require("null-ls")

      local code_actions = nonels.builtins.code_actions
      local diagnostics = nonels.builtins.diagnostics
      local formatting = nonels.builtins.formatting
      local hover = nonels.builtins.hover
      local completion = nonels.builtins.completion

      local ls_sources = {
        --formatting.sylua,
        formatting.nixfmt,
        diagnostics.statix,
        code_actions.statix,
        diagnostics.deadnix,
      }

      nonels.setup({
        diagnostics_format = "[#{m}] #{s} (#{c})",
        debounce = 250,
        default_timeout = 5000,
        sources = ls_sources,
      })

      vim.diagnostic.config({
        float = { border = "single" },
        update_in_insert = true,
        virtual_text = false,
        virtual_lines = {
          enable = true,
          current_line = true,
        },
        underline = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = vim.g.icons.diagnostics.error,
            [vim.diagnostic.severity.WARN] = vim.g.icons.diagnostics.warn,
            [vim.diagnostic.severity.INFO] = vim.g.icons.diagnostics.info,
            [vim.diagnostic.severity.HINT] = vim.g.icons.diagnostics.hint,
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = vim.g.icons.diagnostics.error,
            [vim.diagnostic.severity.WARN] = vim.g.icons.diagnostics.warn,
            [vim.diagnostic.severity.INFO] = vim.g.icons.diagnostics.info,
            [vim.diagnostic.severity.HINT] = vim.g.icons.diagnostics.hint,
          },
        },
      })


      
      vim.lsp.enable({
        "clangd",
        "cmake",
        "csharp_ls",
        "gdscript",
        "gdshader_lsp",
        "glsl_analyzer",
        "gopls",
        "gradle_ls",
        "html",
        "jsonls",
        "lua_ls",
        "marksman",
        "nil_ls",
        "openscad_lsp",
        "pyright",
        "qmlls",
        "rustanalyzer",
        "texlab",
        "wgsl_analyzer",
        "verible",
        "yamlls",
      })
    end,
  },
}

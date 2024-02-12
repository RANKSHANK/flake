return {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    dir = require("lazy-nix-helper").get_plugin_path("lsp_lines"),
    config = function ()
        vim.diagnostic.config({
            virtual_text = false,
        })
        require("lsp_lines").setup()
    end
}

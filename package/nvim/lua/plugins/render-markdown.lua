return {
  "render-markdown.nvim",
  ft = { "md" },
  after = function()
    require("render-markdown").setup({
      completions = {
        blink = { enabled = true },
      },
    })
  end,
}

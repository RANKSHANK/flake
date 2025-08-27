return {
  {
    "render-markdown.nvim",
    ft = { "md" },
    after = function()
      require("render-markdown").setup({
        completions = {
          blink = { enabled = true },
        },
      })
    end,
  },
  {
    "image.nvim",
    lazy = false,
    after = function ()
      require("image").setup({
        processor = "magick_cli",
        backend = "kitty",
      })
    end,
  },
}

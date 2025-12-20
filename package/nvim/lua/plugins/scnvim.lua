return {
  "scnvim",
  ft = "supercollider",
  after = function ()
    require("scnvim").setup({
      postwin = {
        float = {
          enable = true,
        },
      },
    })
  end

}

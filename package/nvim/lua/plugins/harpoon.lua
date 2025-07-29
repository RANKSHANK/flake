local harpoon = require("harpoon")
local function genBinds(count, binds)
  for _, str in pairs({ "", "h" }) do
    for i = 0, count, 1 do
      table.insert(binds, {
        "<leader>" .. str .. tostring(i),
        desc = tostring(i),
        icon = "󱡅",
        hidden = #str == 0, -- Hide the top menu binds
        function()
          harpoon:list():select(i)
        end,
      })
    end
  end
  return binds
end
return {
  "harpoon",
  before = function()
    require("lz.n").trigger_load("plenary")
  end,
  after = function()
    harpoon:setup({
      settings = {
        save_on_toggle = true,
      },
    })
    local ext = require("harpoon.extensions")
    harpoon:extend(ext.builtins.highligh_current_file())
  end,
  binds = genBinds(9, {
    {
      "<leader>h",
      desc = "Harpoon",
      icon = "󱡅",
    },
    {
      "<leader>hu",
      function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "UI",
    },
    {
      "<leader>ha",
      function()
        harpoon:list():add()
      end,
      desc = "Add File",
    },
  }),
}

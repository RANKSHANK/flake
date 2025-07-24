local state = require("lz.n.handler.state").new()

local M = {
  spec_field = "binds",
  add = function(plugin)
    if not plugin.binds then
      return
    end
    state.insert(plugin)
    package.loaded["which-key"].add(plugin.binds)
  end,
  del = state.del,
  lookup = state.lookup_plugin,
}

return M

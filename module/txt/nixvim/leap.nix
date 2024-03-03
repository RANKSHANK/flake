{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins.leap = {
            enable = true;
            addDefaultMappings = false;
        };
        keymaps = [
            {
                key = "s";
                action = ''function ()
  local focusable_windows = vim.tbl_filter(
    function (win) return vim.api.nvim_win_get_config(win).focusable end,
    vim.api.nvim_tabpage_list_wins(0)
  )
  require('leap').leap { target_windows = focusable_windows }
end'';
                lua = true;
            }
        ];
    };
}

{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {

    programs.nixvim.autoCmd = let
        hiddenBufs = 5;
    in [
        {
            event = [ "BufHidden" ];
            desc = "Auto unload unmodified buffers after leaving";
            callback = {
              __raw = ''
	      	function()
                local found = {}
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        if vim.api.nvim_win_get_buf(win) == bufnr then goto continue end
                    end
                    if vim.api.nvim_buf_get_option(bufnr, 'modified') then goto continue end
                    table.insert(found, bufnr)
                    ::continue::
                end
                if #found > ${toString hiddenBufs} then
                    for i = 1, #found - ${toString hiddenBufs} do
                        vim.api.nvim_buf_delete(found[i], {} )
                    end
                end
            end
            '';
          };
        }
    ];

}

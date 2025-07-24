local omnileap = function ()
    require('leap').leap { target_windows = vim.tbl_filter(
        function (win) return vim.api.nvim_win_get_config(win).focusable end,
        vim.api.nvim_tabpage_list_wins(0)
    )}
end
return {
    "ggandor/leap.nvim",
    dir = require("lazy-nix-helper").get_plugin_path("leap.nvim"),
    binds = {
        {
            "gs",
            mode = { "n", "x", "o" },
            desc = "Leap Remote",
            function()
                require("leap.remote
            end,
        },
    },
    config = function(_, opts)
        local leap = require("leap")
        for k, v in pairs(opts) do
            leap.opts[k] = v
        end
        leap.add_default_mappings(false)
    end,
}

{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        extraConfigLuaPost = ''
            require('lualine').setup({
                sections = {},
            })
        '';
        plugins.lualine = {
            enable = true;
            globalstatus = true; disabledFiletypes = rec { statusline = [
                    "oil"
                    "telescope"
                ];
                winbar = statusline;
            };
            winbar = {
                lualine_a = [
                {
                    name = "branch";
                }
                ];
                lualine_b = [
                {
                    name = "filetype";
                    extraConfig = {
                        padding = {
                            right = 1;
                            left = 1;
                        };
                        icon_only = true;
                        separator = false;
                    };
                }
                {
                    name = "filename";
                    extraConfig = {
                    padding.left = 0;
                        path = 0;
                        symbols =  {
                             inherit (config.icons.fileStatus) modified readonly unnamed;
                        };
                    };
                }
                ];
                lualine_c = [ #TODO: Reimplement git diff. lualines is a bit lacking imo
                {
                    name = "diagnostics";
                }
                ];
            };
        };
    };
}

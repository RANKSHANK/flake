{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins.lualine = {
            enable = true;
            globalstatus = true;
            disabledFiletypes = rec {
                statusline = [
                    "oil"
                    "telescope"
                ];
                winbar = statusline;
            };
            sections = {
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
                lualine_c = [
                {
                    name = "diff";
                    extraConfig = {
                        symbols = config.icons.git;
                    };
                }
                    "diagnostic"
                ];
            };
        };
    };
}

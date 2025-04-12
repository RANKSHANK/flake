{ config, lib, ... }: let
    inherit (lib.modules) mkIf;
    inherit (lib.nvim.dag) entryAnywhere;
    cfg = config.vim.filetree.oil;
in {
    config = mkIf cfg.enable {
        vim = {
            lazy.plugins.oil-nvim = {
                package = "oil-nvim";
                setupModule = "oil";
                inherit (cfg) setupOpts;
                cmd = [ "Oil" ];
            };
        };
    };
}

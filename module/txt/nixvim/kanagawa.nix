{ config, lib, ... }: let
    mk = lib.hasSuffix "kanagawa.yaml" config.stylix.base16Scheme;
in lib.mkSubmodule "nixvim" config {
    stylix.targets.nixvim.enable = lib.mkIf mk false;
    programs.nixvim = lib.mkIf mk{
        colorschemes.kanagawa = {
            enable = true;
        };
    };
}

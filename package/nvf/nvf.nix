{ inputs, pkgs, lib, ... }: let
    inherit (inputs) nvf;
in (nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [
        (import ../../module/txt/nvf/nvf-init.nix {
            inherit inputs pkgs lib;
        })
    ];
}).neovim

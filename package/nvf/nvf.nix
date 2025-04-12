{ pkgs, inputs, ... }: let
  lib = pkgs.lib.extend (_: final: inputs.nvf.lib // import ../../lib { inherit (pkgs) lib; });
in (lib.neovimConfiguration {

    inherit pkgs;

    extraSpecialArgs = {
      inherit lib inputs;
    };

    modules = lib.listNixFilesRecursively ./config;
}).neovim

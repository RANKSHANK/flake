{
  user,
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let

  plugins = import ./plugins.nix pkgs;

in lib.mkModule "neovim" [ "shell" ] config {
    nixpkgs.overlays = [
      (
        final: prev: {
          neovim = {
            buildInputs = lib.flatten [
              prev.buildInputs
              (builtins.attrValues {
                inherit (pkgs) rg fzf;
              })
            ];
          };
        }
      )
    ];

    home-manager.users.${user} = {
      xdg.configFile.nvim = {
        source = ./config;
        recursive = true;
      };

      programs.neovim = {
        plugins = builtins.attrValues plugins;
        enable = true;
        defaultEditor = true;
        package = inputs.neovim-nightly.packages.${pkgs.system}.neovim;

        extraLuaConfig = import ./init.nix lib config plugins;
      };

  };
}

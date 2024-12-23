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

    home-manager.users.${user} = {
      stylix.targets.neovim.enable = false;
      stylix.targets.vim.enable = false;
      xdg.configFile.nvim = {
        source = ./config;
        recursive = true;
      };

      programs.neovim = {
        plugins = builtins.attrValues plugins;
        enable = true;
        defaultEditor = true;
        package = inputs.neovim-nightly.packages.${pkgs.system}.neovim.overrideAttrs (final: prev: {
            buildInputs = prev.buildInputs ++ (builtins.attrValues {
                inherit (pkgs) fd;
            });
        });

        extraLuaConfig = import ./init.nix lib config plugins;
      };

  };
}

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

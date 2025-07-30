{
  inputs,
  lib,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "neovim" ["shell"] {
    environment.systemPackages = [
      inputs.self.packages.${pkgs.system}.nvim
    ];
    home-manager.users.${user} = {
      home.sessionVariables.EDITOR = "nvim";
    };
  }

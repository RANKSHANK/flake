{
  inputs,
  pkgs,
  lib,
  user,
  ...
}:
lib.mkModule "neovim" ["shell"] {
  environment.systemPackages = [
    inputs.self.packages.${pkgs.system}.nvim
  ];
  home-manager.users.${user} = {
    home.sessionVariables.EDITOR = "nvim";
  };
}

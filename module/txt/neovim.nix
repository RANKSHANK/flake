{
  inputs,
  pkgs,
  lib,
  ...
}:
lib.mkModule "neovim" ["shell"] {
  environment.systemPackages = [
    inputs.self.packages.${pkgs.system}.nvim
  ];
}

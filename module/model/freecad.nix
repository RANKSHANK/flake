{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
lib.mkModule "freecad" ["desktop" "cad"] {
  environment.systemPackages = [
    # (lib.ternary (lib.isEnabled "wayland" config) freecad-wayland freecad)
    inputs.nix-stable.legacyPackages.${pkgs.system}.freecad
    # pkgs.freecad
  ];
}

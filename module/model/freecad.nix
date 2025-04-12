{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: lib.mkModule "freecad" [ "desktop" "cad" ] {
    environment.systemPackages = with inputs.nix-staging.legacyPackages.${pkgs.system}; [
      (lib.ternary (lib.isEnabled "wayland" config) freecad-wayland freecad)
      # inherit (inputs.nix-stable.legacyPackages.${pkgs.system}) freecad;
    ];
}

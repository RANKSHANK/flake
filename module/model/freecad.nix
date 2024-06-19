{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: lib.mkModule "freecad" [ "desktop" "cad" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) freecad;
      # inherit (inputs.nix-stable.legacyPackages.${pkgs.system}) freecad;
    };
}

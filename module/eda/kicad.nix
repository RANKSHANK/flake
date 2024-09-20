{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: lib.mkModule "kicad" [ "desktop" "cad" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) kicad;
      # inherit (inputs.nix-stable.legacyPackages.${pkgs.system}) kicad; # OOM -_-
    };
}

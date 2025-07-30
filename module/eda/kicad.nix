{
  inputs,
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "kicad" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      # inherit (pkgs) kicad;
      inherit (inputs.nix-stable.legacyPackages.${pkgs.system}) kicad; # OOM -_-
    };
  }

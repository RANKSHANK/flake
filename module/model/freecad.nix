{
  pkgs,
  lib,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "freecad" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) freecad;
    };
  }

{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "cura" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) cura-appimage;
    };
  }

{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "prusa" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) prusa-slicer;
    };
  }

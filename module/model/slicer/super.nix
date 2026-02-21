{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "super" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) super-slicer;
    };
  }

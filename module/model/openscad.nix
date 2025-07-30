{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "openscad" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) openscad;
    };
  }

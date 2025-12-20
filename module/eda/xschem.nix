{
  lib,
  pkgs,
  util,
  ...
}:
let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "xschem" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) xschem;
    };
  }

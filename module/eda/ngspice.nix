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
  mkModule "ngspice" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) ngspice;
    };
  }

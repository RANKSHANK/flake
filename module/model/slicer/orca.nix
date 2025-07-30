{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "orca" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) orca-slicer;
    };
  }

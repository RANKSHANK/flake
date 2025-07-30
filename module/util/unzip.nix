{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "unzip" ["shell"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) unzip;
    };
  }

{
  pkgs,
  lib,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "appimage" ["repo" "desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) appimage-run;
    };
  }

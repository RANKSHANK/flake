{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "aseprite" ["desktop" "graphics"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) aseprite;
    };
  }

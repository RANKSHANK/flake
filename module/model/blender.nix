{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "blender" ["cad" "desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) blender;
    };
  }

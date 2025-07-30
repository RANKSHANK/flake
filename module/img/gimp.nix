{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "gimp" ["graphics" "desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) gimp;
    };
  }

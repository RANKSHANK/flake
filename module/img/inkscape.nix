{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "inkscape" ["graphics" "desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) inkscape-with-extensions;
    };
  }

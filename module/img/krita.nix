{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "krita" ["graphics" "desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) krita;
    };
  }

{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "pcmanfm" ["desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) pcmanfm;
    };
  }

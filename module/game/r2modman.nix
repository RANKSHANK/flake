{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "r2modman" ["desktop" "gaming"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) r2modman;
    };
  }

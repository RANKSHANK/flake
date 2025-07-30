{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "satisfactory-mod-manager" ["desktop" "gaming"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) satisfactorymodmanager;
    };
  }

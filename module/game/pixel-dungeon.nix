{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "pixel-dungeon" ["desktop" "gaming"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) shattered-pixel-dungeon;
    };
  }

{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "minecraft" ["gaming" "desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) prismlauncher;
    };
  }

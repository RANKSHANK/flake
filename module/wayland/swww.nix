{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "swww" ["desktop" "wayland"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) swww;
    };
  }

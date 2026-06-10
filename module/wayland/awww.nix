{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "awww" ["desktop" "wayland"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) awww;
    };
  }

{
  pkgs,
  lib,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "rclone" ["connectivity" "sync"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) rclone;
    };
  }

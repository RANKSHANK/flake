{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "bat" ["shell"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) bat;
    };
  }

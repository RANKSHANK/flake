{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "ripgrep" ["shell"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) ripgrep;
    };
  }

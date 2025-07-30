{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "bitwarden" ["desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) bitwarden-desktop;
    };
  }

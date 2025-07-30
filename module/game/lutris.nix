{
  pkgs,
  lib,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "lutris" ["gaming" "desktop"] {
    environment.systemPackages = attrValues {
      lutris = pkgs.lutris.override {
        extraPkgs = pkgs:
          attrValues {
            inherit (pkgs) winetricks;
          };
      };
    };
  }

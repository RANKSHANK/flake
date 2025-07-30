{
  pkgs,
  lib,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "octave" ["math" "desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) octave;
      inherit (pkgs.octavePackages) symbolic;
    };
  }

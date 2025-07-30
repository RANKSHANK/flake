{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "kdenlive" ["desktop" "video"] {
    environment.systemPackages = attrValues {
      inherit (pkgs.kdePackages) kdenlive;
    };
  }

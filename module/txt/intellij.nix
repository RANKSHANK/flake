{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "intellij" ["desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs.jetbrains) idea-community;
    };
  }

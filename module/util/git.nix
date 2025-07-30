{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "git" ["shell"] {
    programs = {
      git.enable = true;
    };
    environment.systemPackages = attrValues {
      inherit (pkgs) gh;
    };
  }

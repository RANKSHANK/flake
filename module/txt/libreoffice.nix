{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "libreoffice" ["desktop" "office"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) hunspell libreoffice-qt;
      inherit (pkgs.hunspellDicts) en_US en_AU;
    };
  }

{
  pkgs,
  lib,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "xournal" ["desktop" "office"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) xournalpp;
    };
  }

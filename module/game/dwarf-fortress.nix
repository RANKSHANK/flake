{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "dwarf-fortress" ["desktop" "gaming"] {
    environment.systemPackages = attrValues {
      # inherit (pkgs) openal;
      inherit (pkgs.dwarf-fortress-packages) dwarf-fortress-full;
    };
  }

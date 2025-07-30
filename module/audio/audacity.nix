{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (util) mkModule;
in
  mkModule "audacity" ["desktop" "audio"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) audacity;
    };
  }

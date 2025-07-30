{
  pkgs,
  util,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (util) mkModule;
in
  mkModule "guitarix" ["audio" "desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) guitarix;
    };
  }

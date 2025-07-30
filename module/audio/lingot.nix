{
  pkgs,
  util,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (util) mkModule;
in
  mkModule "lingot" ["audio" "desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) lingot;
    };
  }

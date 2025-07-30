{
  pkgs,
  util,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (util) mkModule;
in
  mkModule "livecaptions" ["audio" "desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) livecaptions;
    };
  }

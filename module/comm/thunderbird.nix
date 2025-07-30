{
  pkgs,
  util,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (util) mkModule;
in
  mkModule "thunderbird" ["desktop" "communication"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) thunderbird;
    };
  }

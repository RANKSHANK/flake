{
  pkgs,
  lib,
  util,
  ...
}: let
  inherit (builtins) attrValues elem;
  inherit (lib) getName;
  inherit (util) mkModule;
in
  mkModule "discord" ["desktop" "communication"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) vesktop;
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      elem (getName pkg) [
        "discord"
      ];
  }

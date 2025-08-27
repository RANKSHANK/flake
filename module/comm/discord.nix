{
  pkgs,
  lib,
  user,
  util,
  ...
}: let
  inherit (builtins) attrValues elem;
  inherit (lib) getName;
  inherit (util) mkModule;
in
  mkModule "discord" ["desktop" "communication"] {
    home-manager.users.${user}.programs.vesktop.enable = true;

    nixpkgs.config.allowUnfreePredicate = pkg:
      elem (getName pkg) [
        "discord"
      ];
  }

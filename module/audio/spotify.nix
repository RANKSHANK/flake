{
  inputs,
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (builtins) attrValues elem;
  inherit (lib) getName;
  inherit (util) mkModule;
in
  mkModule "spotify" ["audio" "desktop"] {
    programs.spicetify = {
      enable = true;
      enabledExtensions = attrValues {
        inherit
          (inputs.spicetify.legacyPackages.${pkgs.system}.extensions)
          adblock
          hidePodcasts
          keyboardShortcut
          shuffle
          trashbin
          ;
      };
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      elem (getName pkg) [
        "spotify"
      ];
  }

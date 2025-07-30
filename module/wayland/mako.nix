{
  lib,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues mapAttrs;
  inherit (util) isString mkModule ternary;
in
  mkModule "mako" ["desktop" "wayland"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) mako libnotify;
    };

    home-manager.users.${user} = {
      services.mako = {
        enable = true;
        settings = mapAttrs (_: attr: ternary (isString attr) attr (toString attr)) {
          default-timeout = toString 8000;
          border-radius = toString 12;
          text-alignment = "center";
          icons = 1;
          width = 300;
          height = 110;
        };
      };
    };
  }

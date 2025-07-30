{
  pkgs,
  lib,
  user,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
  clip-menu = pkgs.writeShellScriptBin "clip-menu" ''
    #!/usr/bin/env bash
    if command -v rofi &> /dev/null; then
        cliphist list | rofi -dmenu | cliphist decode | wl-copy
    fi
  '';
in
  mkModule "cliphist" ["desktop" "wayland"] {
    exec-once = [
      "wl-clip-persist"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
    ];

    environment.systemPackages = attrValues {
      inherit (pkgs) wl-clipboard wl-clip-persist;
    };

    home-manager.users.${user} = {
      services.cliphist = {
        enable = true;
        extraOptions = [
          "-max-items=1"
        ];
      };
    };
  }

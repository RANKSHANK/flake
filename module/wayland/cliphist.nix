{
  pkgs,
  config,
  lib,
  user,
  ...
}: let
  clip-menu = pkgs.writeShellScriptBin "clip-menu" ''
    #!/usr/bin/env bash
    if command -v rofi &> /dev/null; then
        cliphist list | rofi -dmenu | cliphist decode | wl-copy
    fi
  '';
in
  lib.mkModule "cliphist" ["desktop" "wayland"] {
    exec-once = [
      "wl-clip-persist"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
    ];

    environment.systemPackages = builtins.attrValues {
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

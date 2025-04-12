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
in lib.mkModule "cliphist" [ "desktop" "wayland" ] {

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) wl-clipboard;
    };

    home-manager.users.${user} = {
      services.cliphist = {
        enable = true;
        # package = pkgs-stable.legacyPackages.${pkgs.system}.cliphist;
        extraOptions = [
            "-max-items=1"
        ];

    };

    wayland.windowManager.hyprland.settings.exec-once = [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
    ];
  };
}

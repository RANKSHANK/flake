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
in lib.mkModule "cliphist" [ "desktop" "wayland" ] config {
    # shared.compositorInit = [
    #   "wl-paste --type text --watch cliphist store"
    #   "wl-paste --type image --watch cliphist store"
    # ];
    # TODO: service
    # sharedeybinds = [
    #   "L-v=clip-menu"
    # ];

    keybinds = lib.mkIfEnabled "rofi" config [
      {
        name = "Cliphist";
        mods = ["super"];
        combo = ["v"];
        exec = "clip-menu";
      }
    ];

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) cliphist wl-clipboard;
      clip-menu = lib.mkIfEnabled "rofi" config clip-menu;
    };

    home-manager.users.${user} = {
      services.cliphist.enable = true;
  };
}

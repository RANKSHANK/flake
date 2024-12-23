{
  pkgs,
  config,
  lib,
  inputs,
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

    # keybinds = lib.mkIfEnabled "rofi" config [
    #   {
    #     name = "Cliphist";
    #     mods = ["super"];
    #     combo = ["v"];
    #     exec = "clip-menu";
    #   }
    # ];

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) wl-clipboard;
      # clip-menu = lib.mkIfEnabled "rofi" config clip-menu;
    };

    home-manager.users.${user} = {
      services.cliphist = {
        enable = true;
        package = inputs.nix-stable.legacyPackages.${pkgs.system}.cliphist;
        extraOptions = [
            "-max-items=1"
        ];
    };
  };
}

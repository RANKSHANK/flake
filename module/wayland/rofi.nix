{
  config,
  lib,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "rofi" ["desktop" "wayland"] {
    keybinds = [
      {
        name = "Rofi App Menu";
        mods = ["super"];
        exec = "pkill rofi || rofi -show drun";
      }
      {
        name = "Rofi Symbol Menu";
        mods = ["super"];
        combo = ["space"];
        exec = "rofi -modi \"emoji:${pkgs.rofimoji}/bin/rofimoji\" -show emoji";
      }
      {
        name = "Rofi Power Menu";
        mods = ["ctrl" "alt"];
        combo = ["delete"];
        exec = "rofi -show power-menu -modi power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
      }
    ];

    home-manager.users.${user} = {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi;
        plugins = attrValues {
          inherit (pkgs) rofimoji rofi-power-menu;
        };
        extraConfig = {
          sidebar-mode = true;
          icon-theme = config.stylix.cursor.name;
          icon-padding = "10px 10px";
          show-icons = true;
          display-run = " ";
          display-drun = "󱄅 ";
          display-window = "󰖲 ";
          display-ssh = "󰣀 ";
        };
      };
      xdg.configFile."rofimoji.rc".text = ''
        action = copy
        files = [ math ]
      '';
    };
  }

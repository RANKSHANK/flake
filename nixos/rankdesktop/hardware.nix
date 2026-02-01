{
  config,
  lib,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkIfEnabled;
in {
  monitors = {
    a = {
      connection = "DP-3";
      horizontal = 1920;
      vertical = 1080;
      refreshRate = 144;
    };
    b = {
      connection = "HDMI-A-2";
      horizontal = 1920;
      vertical = 1080;
      xPos = 1;
    };
    c = {
      connection = "DVI-I-1";
      horizontal = 1280;
      vertical = 1024;
      refreshRate = 60;
      xPos = -1;
    };
  };

  home-manager.users.${user}.wayland.windowManager.hyprland.settings.device = mkIfEnabled "hyprland" config [
    {
      name = "tablet-monitor-pen";
      transform = 0;
      output = "HDMI-A-2";
    }
  ];

  hardware = {
    enableAllFirmware = true;
  };
}

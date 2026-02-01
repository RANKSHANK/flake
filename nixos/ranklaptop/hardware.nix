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
      connection = "eDP-1";
      horizontal = 1920;
      vertical = 1080;
      refreshRate = 60;
    };
    b = {
      connection = "DP-1";
      horizontal = 1920;
      vertical = 1080;
      refreshRate = 60;
      yPos = 1;
      xPos = 1;
    };
    c = {
      connection = "HDMI-A-1";
      horizontal = 1920;
      vertical = 1080;
      refreshRate = 60;
      yPos = 1;
      xPos = 0;
    };
  };

  home-manager.users.${user}.wayland.windowManager.hyprland.settings.device = mkIfEnabled "hyprland" config [
    {
      name = "tablet-monitor-pen";
      transform = 0;
      output = "HDMI-A-1";
    }
  ];

  hardware = {
    enableAllFirmware = true;
  };
}

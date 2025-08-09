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
      xPos = 1;
    };
    c = {
      connection = "HDMI-A-4";
      horizontal = 1280;
      vertical = 1024;
      refreshRate = 60;
      xPos = 2;
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
    nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    graphics = {
      enable = true;
      # enable32Bit = true;
      extraPackages = attrValues {
        inherit (pkgs) vaapiVdpau libvdpau-va-gl;
      };
    };
  };
}

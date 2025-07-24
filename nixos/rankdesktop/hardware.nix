{
  lib,
  pkgs,
  user,
  config,
  ...
}: {
  config = {
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

    home-manager.users.${user}.wayland.windowManager.hyprland.settings.device = lib.mkIfEnabled "hyprland" config [
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
        extraPackages = builtins.attrValues {
          inherit (pkgs) vaapiVdpau libvdpau-va-gl;
        };
      };
    };
  };
}

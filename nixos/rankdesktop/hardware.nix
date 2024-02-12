{pkgs, ...}: {
  config = {
    monitors = {
      one = {
        connection = "DP-3";
        horizontal = 1920;
        vertical = 1080;
        refreshRate = 144;
      };
      two = {
        connection = "DVI-I-1";
        horizontal = 1920;
        vertical = 1080;
      };
      three = {
        connection = "HDMI-A-2";
        horizontal = 1920;
        vertical = 1080;
        xPos = 1;
      };
    };

    hardware = {
      enableAllFirmware = true;
      nvidia = {
        prime = {
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
      opengl = {
        enable = true;
        driSupport32Bit = true;
        extraPackages = builtins.attrValues {
          inherit (pkgs) vaapiVdpau libvdpau-va-gl;
        };
      };
    };
  };
}

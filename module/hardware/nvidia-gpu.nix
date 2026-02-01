{
  lib,
  config,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "nvidia-gpu" [] {
    boot = {
      kernelModules = ["nvidia"];
      kernelParams = [
        "module_blacklist=nouveau"
      ];
    };
    services.xserver.videoDrivers = [
      "modesetting"
      "nvidia"
    ];
    hardware = {
      graphics.enable = true;
      nvidia = {
        open = false;
        powerManagement.enable = false;
        modesetting.enable = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
      graphics = {
        enable32Bit = lib.mkForce true;
        extraPackages = attrValues {
          inherit (pkgs) libva-vdpau-driver;
        };
      };
    };
  }

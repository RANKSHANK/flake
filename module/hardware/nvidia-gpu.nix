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
    services.xserver.videoDrivers = ["nvidia"];
    hardware = {
      nvidia = {
        open = false;
        modesetting.enable = true;
        powerManagement.enable = false;
        nvidiaSettings = false;
        forceFullCompositionPipeline = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          sync.enable = false;
        };
      };
      graphics = {
        enable32Bit = lib.mkForce true;
        extraPackages = attrValues {
          inherit (pkgs) nvidia-vaapi-driver;
        };
      };
    };
  }

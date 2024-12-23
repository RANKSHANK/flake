{
  lib,
  config,
  pkgs,
  ...
}: lib.mkModule "nvidia-gpu" [] config {
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
        extraPackages = builtins.attrValues {
          inherit (pkgs) nvidia-vaapi-driver;
        };
      };
    };
}

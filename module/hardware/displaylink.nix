{ config, lib, pkgs, ... }:

lib.mkModule "displaylink" [] { 
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) displaylink;
    };

    services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

    boot = {
      extraModulePackages = [ config.boot.kernelPackages.evdi ];
      initrd = {
        kernelModules = [
          "evdi"
        ];
      };
    };
}


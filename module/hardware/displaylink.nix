{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) attrValues;
in {
  environment.systemPackages = attrValues {
    inherit (pkgs) displaylink;
  };

  services.xserver.videoDrivers = ["displaylink" "modesetting"];

  boot = {
    extraModulePackages = [config.boot.kernelPackages.evdi];
    initrd = {
      kernelModules = [
        "evdi"
      ];
    };
  };
}

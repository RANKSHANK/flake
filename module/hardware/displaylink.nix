{
  config,
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in mkModule "displaylink" [ "desktop" ] {
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

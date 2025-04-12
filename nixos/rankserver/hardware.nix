{ lib, pkgs, user, config, ...}: {
  config = {

    hardware = {
      enableRedistributableFirmware = true;
    };
  };
}

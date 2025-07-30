{util, ...}: let
  inherit (util) mkModule;
in
  mkModule "bluetooth" ["connectivity"] {
    services.blueman.enable = true;

    hardware.bluetooth = {
      enable = true;
    };
  }

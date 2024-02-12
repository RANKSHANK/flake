{
  lib,
  config,
  ...
}: lib.mkModule "bluetooth" [ "connectivity" ] config {
    services.blueman.enable = true;

    hardware.bluetooth = {
      enable = true;
    };
}

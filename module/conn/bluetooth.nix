{
  lib,
  ...
}: lib.mkModule "bluetooth" [ "connectivity" ] {
    services.blueman.enable = true;

    hardware.bluetooth = {
      enable = true;
    };
}

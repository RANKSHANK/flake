{
  lib,
  config,
  ...
}: lib.mkModule "ssh" [ "connectivity" ] config {
    services.openssh.enable = true;
}

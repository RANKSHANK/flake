{
  lib,
  config,
  user,
  ...
}: lib.mkModule "netmanager" [ "connectivity" ] config {
    networking = {
      networkmanager = {
        enable = true;
      };
    };

    users.users.${user}.extraGroups = [ "networking" ]; # config {
}

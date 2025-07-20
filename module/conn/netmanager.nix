{
  lib,
  config,
  user,
  ...
}: lib.mkModule "netmanager" [ "connectivity" ] {
    networking = {
      networkmanager = {
        enable = true;
      };
    };

    users.users.${user}.extraGroups = [ "networkmanager" ];
}

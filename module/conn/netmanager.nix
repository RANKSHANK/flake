{
  user,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "netmanager" ["connectivity"] {
    networking = {
      networkmanager = {
        enable = true;
      };
    };

    users.users.${user}.extraGroups = ["networkmanager"];
  }

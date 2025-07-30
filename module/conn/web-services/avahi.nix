{util, ...}: let
  inherit (util) mkModule;
in
  mkModule "avahi" ["connectivity"] {
    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        nssmdns6 = true;
      };

      resolved = {
        enable = true;
      };
    };
  }

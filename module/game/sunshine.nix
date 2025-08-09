{util, ...}: let
  inherit (util) mkModule;
in
  mkModule "sunshine" ["desktop" "gaming" "stream-host"] {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = false;
    };
  }

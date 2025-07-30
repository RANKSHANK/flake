{util, ...}: let
  inherit (util) mkModule;
in
  mkModule "tailscale" ["connectivity"] {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      openFirewall = true;
    };

    networking.firewall = {
      trustedInterfaces = [
        "tailscale0"
      ];
    };
  }

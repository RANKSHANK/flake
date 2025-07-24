{
  lib,
  config,
  ...
}:
lib.mkModule "tailscale" ["connectivity"] {
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

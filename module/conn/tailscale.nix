{ lib, config, ... }:

lib.mkModule "tailscale" [ "connectivity" ] {
    services.tailscale = {
        enable = true;
    };
}

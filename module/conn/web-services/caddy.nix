{ lib, config, ... }:

lib.mkModule "caddy" [ "server" ] {
    services.caddy = {
        enable = true;
        virtualHosts = (lib.mapAttrs' (name: val: lib.nameValuePair 
            ("${config.base-url}.${name}") 
            {
                extraConfig = ''
                    reverse_proxy ${val}
                '';
            }
        ) config.webservices);
    };

    networking.firewall.allowedTCPPorts = [
        80
        443
    ];
}

{ lib, config, ... }:

lib.mkModule "caddy" [ "server" ] {
    services.caddy = {
        enable = true;
        virtualHosts = (lib.mapAttrs' (subdomain: redir: lib.nameValuePair 
            ("${config.url-head}.${subdomain}.${config.url-tail}") 
            {
                extraConfig = ''
                    reverse_proxy ${redir}
                '';
            }
        ) config.webservices);
    };

    networking.firewall.allowedTCPPorts = [
        80
        443
    ];
}

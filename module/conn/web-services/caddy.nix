{ lib, config, pkgs, ... }:

lib.mkModule "caddy" [ "server" ] {
    services.caddy = {
        enable = true;
        package = pkgs.caddy.withPlugins {
            plugins = [
                "github.com/caddy-dns/cloudflare@v0.2.1"
            ];
            hash =  "sha256-2D7dnG50CwtCho+U+iHmSj2w14zllQXPjmTHr6lJZ/A=";
        };
        virtualHosts = (lib.mapAttrs' (subdomain: redir: lib.nameValuePair 
            ("${subdomain}.${config.baseURL}") 
            {
                extraConfig = ''
                    reverse_proxy ${redir}

                    tls {
                        dns cloudflare {$APIKEY}
                        resolvers 1.1.1.1
                    }
                '';
            }

        ) config.webservices);
        environmentFile = "/etc/caddy/env";
    };

    networking.firewall.allowedTCPPorts = [
        80
        443
    ];
}

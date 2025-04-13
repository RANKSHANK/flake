{ lib, config, ... }:

lib.mkModule "nginx" [ "server" "connectivity" ] {
    services.nginx = {
        enable = true;
        virtualHosts.${config.nginx.base-url} = {
            locations."/" = {
                return = "200 <html><body>Dead End</body></html>";
                extraConfig = ''
                    default_type text/html;
                '';
            };
        };
    };

    nginx.base-url = lib.mkDefault config.networking.hostName;

    options.nginx = {
        base-url = lib.mkOption {
            type = lib.types.str; 
            description = "Base URL for the server";
        };
    };
}

{ lib, config, ... }:

lib.mkModule "nginx" [] {
    services.nginx = {
        enable = true;
        virtualHosts.${config.nginx.base-url} = {
            locations = {
                "/" = {
                    return = "200 <html><body>Dead End</body></html>";
                    extraConfig = ''
                        default_type text/html;
                    '';
                };
                "/robots.txt" = {
                    extraConfig = ''
                        rewrite ^/(.*)  $1;
                        return 200 "User-agent: *\nDisallow: /";
                    '';
                };
            };
        };
    };
}

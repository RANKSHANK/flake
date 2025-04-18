{ config, lib, ... }:

lib.mkModule "changedetection-io" [ "server" ] {

    nixpkgs.overlays = [ 
        (self: super: {
            changedetection-io = super.changedetection-io.overridePythonAttrs (old: {
                propagatedBuildInputs = super.changedetection-io.propagatedBuildInputs ++ [
                    super.python3.pkgs.extruct
                ];
            });
        } )
    ];

    services = {
        changedetection-io = {
            enable = true;
            # webDriverSupport = true;
            playwrightSupport = true;
        
        };
    };

    webservices."changedetection-io" = "${config.services.changedetection-io.listenAddress}.${toString config.services.changedetection-io.port}";

    users.users.changedetection-io.extraGroups = [
        config.services.nginx.user
    ];

    systemd.services.changedetection-io = {
        after = lib.mkForce [ "network-online.target" ];
        wants = lib.mkForce [ "network-online.target" ];
    };

    
}

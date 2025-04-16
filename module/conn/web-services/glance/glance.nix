{ config, lib, pkgs, ... }:

lib.mkModule "glance" [ "server" ] {

    services = {
        glance = {
            enable = true;
            settings = {

                branding = {
                    hide-footer = true;
                    logo-text = "󱄅";
                };

                theme = with config.lib.stylix.colors; let
                    conv = hex: lib.pipe hex [
                        (hx: lib.rgbToHsl (lib.hexToRgb hx))
                        (hsl: "${toString hsl.hue} ${toString hsl.saturation} ${toString hsl.luminance}")
                    ];
                in {
                    light = config.stylix.polarity == "light";
                    background-color = conv base00;
                    primary-color = conv base05;
                    positive-color = conv base0B;
                    negative-color = conv base08;
                    contrast-multiplier = 1.2;
                    text-saturation-multiplier = 1.2;
                    custom-css-file = pkgs.writeText "glance-webfont" ''@import "https://www.nerdfonts.com/assets/css/webfont.css"'';
                };

                pages = let
                    widgets = builtins.foldl' (attr: file:
                        attr // { ${lib.getModuleName file} = import file { inherit config lib pkgs widgets; }; }
                    ) {} (lib.listNixFilesRecursively ./widgets);
                in map (attr: removeAttrs attr [ "prio" ]) (builtins.sort (l: r: l.prio < r.prio) (map (page: 
                    (import page {
                        inherit config lib pkgs widgets;
                    } // { name = lib.head (lib.splitString "." (lib.getModuleName page)); })
                ) (lib.ternary (builtins.pathExists ./pages) (lib.ternary config.decrypted (lib.listNixFilesRecursively ./pages) []) [])));
                };

        };

        nginx.virtualHosts."glance.${config.nginx.base-url}" = {
            listen = [{
                addr = config.services.glance.settings.server.host;
                port = config.services.glance.settings.server.port;
            }];
        };

    };

    systemd.services = lib.mkIf config.services.changedetection-io.enable {

        glance = {
            after = lib.mkForce [ "glance-env.service" ];
            wants = lib.mkForce [ "glance-env.service" ];
            serviceConfig = {
                EnvironmentFile = "/tmp/glance-data";
            };
        };

        changedetection-io = {
            wantedBy = [ "glance-env.service" ];
            before = [ "glance-env.service" ];
        };

        glance-env = {
            description = "Glance - Env Var loading";
            after = [ "changedetection-io.service" ];
            wantedBy = [ "glance.service" ];
            before = [ "glance.service" ];
            serviceConfig = {
                ExecStart = "${lib.getExe (pkgs.writeShellScriptBin "glance-env" ''
                    #!/usr/bin/env bash
                    ${pkgs.coreutils}/bin/touch /tmp/glance-data
                    chown root:root /tmp/glance-data
                    chmod 600 /tmp/glance-data
                    API=$(${pkgs.jq}/bin/jq -r .settings.application.api_access_token ${config.services.changedetection-io.datastorePath}/url-watches.json)
                    echo "CHANGEDETECTION_TOKEN=$API" > /tmp/glance-data
                '')}";
            };

        };

    };
    
}

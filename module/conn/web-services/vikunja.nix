{ config, lib, pkgs-stable , ... }:



lib.mkModule "vikunja" [ "server" ] {

    services = {
        vikunja = {
            enable = true;
            package = pkgs-stable.vikunja;
            frontendScheme = "http";
            frontendHostname = "localhost";
            settings = {
                service = {
                    enableuserdeletion = false;
                };
            };
        };
        nginx.virtualHosts."vikunja.${config.nginx.base-url}" = {
            listen = [{
                addr = config.services.vikunja.frontendHostname;
                port = config.services.vikunja.port;
            }];
        };
    };

    users = {
        users = { 
            vikunja = {
                isSystemUser = true;
                group = "vikunja";
                extraGroups = [
                    config.services.nginx.user
                ];
            };
        };
        groups.vikunja = {};
    };

    systemd.services.vikunja = {
        serviceConfig = {
            Group = "vikunja";
            User = "vikunja";
            WorkingDirectory = "/var/lib/vikunja";
            DynamicUser = lib.mkForce false;
            DevicePolicy = "closed";
            LockPersonality = true;
            PrivateTmp = true;
            PrivateUsers = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectSystem = true;
            ProtectControlGroups = true;
            RestrictNamespaces = true;
            RestrictRealtime = true;
            StateDirectoryMode = 0750;
            standardoutput = "journal";
            StandardError = "journal";
            UMask = "0077";
        };
    };
}

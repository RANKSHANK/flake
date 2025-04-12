{ config, lib, pkgs-stable , ... }:



lib.mkModule "vikunja" [ "server" ] {

    services.vikunja = {
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

    users = {
        users.vikunja = {
            isSystemUser = true;
            group = "vikunja";
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

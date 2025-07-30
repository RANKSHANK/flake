{
  config,
  lib,
  util,
  ...
}: let
  inherit (lib.modules) mkForce;
  inherit (util) mkModule;
in
  mkModule "vikunja" ["server"] {
    services = {
      vikunja = {
        enable = true;
        frontendScheme = "https";
        frontendHostname = "localhost";
        settings = {
          service = {
            enableuserdeletion = false;
          };
        };
      };
    };

    webservices."vikunja" = "${config.services.vikunja.frontendHostname}:${toString config.services.vikunja.port}";

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
        DynamicUser = mkForce false;
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

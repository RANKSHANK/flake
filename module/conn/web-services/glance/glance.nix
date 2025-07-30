{
  config,
  inputs,
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.lists) foldl' head sort;
  inherit (lib.modules) mkForce mkIf;
  inherit (lib.meta) getExe;
  inherit (lib.strings) splitString;
  inherit (lib.trivial) pathExists;
  inherit (util) isDecrypted getModuleName listNixFilesRecursively mkModule ternary;
in
  mkModule "glance" ["server"] {
    services = {
      glance = {
        enable = true;
        environmentFile = "/tmp/glance-data";
        settings = {
          branding = {
            hide-footer = true;
            logo-text = "󱄅";
          };
          pages = let
            widgets = foldl' (
              attr: file:
                attr // {${getModuleName file} = import file {inherit config inputs lib util;};}
            ) {} (listNixFilesRecursively ./widgets);
          in
            map (attr: removeAttrs attr ["prio"]) (sort (l: r: l.prio < r.prio) (map (
              page: (import page {
                  inherit config inputs lib util widgets;
                }
                // {name = head (splitString "." (getModuleName page));})
            ) (ternary (pathExists ./pages) (ternary isDecrypted (listNixFilesRecursively ./pages) []) [])));
        };
      };

      nginx.virtualHosts."glance.${config.nginx.base-url}" = {
        listen = [
          {
            addr = config.services.glance.settings.server.host;
            port = config.services.glance.settings.server.port;
          }
        ];
      };
    };

    webservices."glance" = "${config.services.glance.settings.server.host}:${toString config.services.glance.settings.server.port}";

    systemd.services = mkIf config.services.changedetection-io.enable {
      glance = {
        after = mkForce ["glance-env.service"];
        wants = mkForce ["glance-env.service"];
        serviceConfig = {
          Restart = "always";
          RestartSec = "30";
        };
      };

      changedetection-io = {
        wantedBy = ["glance-env.service"];
        before = ["glance-env.service"];
      };

      glance-env = {
        description = "Glance - Env Var loading";
        after = ["changedetection-io.service"];
        wantedBy = ["glance.service"];
        before = ["glance.service"];
        serviceConfig = {
          ExecStart = "${getExe (pkgs.writeShellScriptBin "glance-env" ''
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

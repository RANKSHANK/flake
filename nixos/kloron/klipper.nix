{
  config,
  lib,
  pkgs,
  self,
  user,
  util,
  ...
}: let
  inherit (lib.attrsets) listToAttrs;
  inherit (lib.lists) filter;
  inherit (lib.modules) mkForce;
  inherit (lib.strings) removePrefix;
  inherit (util) listTargetFilesRecursively;

in{
  services = {
    klipper = {
      package = self.packages.${pkgs.stdenv.system}.kalico;
      enable = true;
      mutableConfig = false;
      user = "klipper";
      group = "klipper";
      configDir = "/etc/klipper";
      configFile = ./klipper/printer.cfg;
    };
    moonraker = {
      address = "0.0.0.0";
      user = "klipper";
      group = "klipper";
      enable = true;
      allowSystemControl = true; # power and systemd units
      settings = {
        history = {};
        authorization = {
          force_logins = true;
          cors_domains = [
            "*.local"
            "*.lan"
            "*://app.fluidd.xyz"
            "*://app.mainsail.xyz"
          ];
          trusted_clients = [
            "10.0.0.0/8"
            "127.0.0.0/8"
            "169.254.0.0/16"
            "172.16.0.0/16"
            "192.168.1.0/24"
            "FE80::/10"
            "::1/128"
          ];
        };

      };
    };
    mainsail = {
      enable = true;
    };
  };

  systemd.services.klipper = {
    preStart = mkForce ""; # Spams cfg copies
  };

  environment = {
    systemPackages = [ config.services.klipper.package ];
    etc = listToAttrs (map
     (filePath: {
        name = "klipper${filePath}";
        value = {
          group = "klipper";
          user = "klipper";
          source = ./klipper/${filePath};
        };
      })
      (filter (name: name != "printer.cfg") (map (dir: removePrefix (toString ./klipper) (toString dir)) (listTargetFilesRecursively ".cfg" ./klipper))));
  };

  users = {
    groups = {
      klipper = {};
    };
    users = {
      klipper = {
        group = "klipper";
        isSystemUser = true;
        extraGroups = [
          "klipper"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    7125
  ];

}

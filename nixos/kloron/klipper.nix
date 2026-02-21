{
  config,
  lib,
  pkgs,
  self,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues listToAttrs;
  inherit (lib.lists) filter;
  inherit (lib.modules) mkForce;
  inherit (lib.strings) removePrefix;
  inherit (util) listTargetFilesRecursively;
  inherit (self.packages.${pkgs.stdenv.system}) kalico;
in {
  services = {
    klipper = {
      package = kalico.override (_: { plugins = attrValues {
        inherit (kalico.kalicoPlugins)
          klipper-led-effect
        ;
      };});
      enable = true;
      mutableConfig = false;
      user = "klipper";
      group = "klipper";
      configDir = "/etc/klipper";
      configFile = ./klipper/printer.cfg;
    };
    moonraker = {
      inherit (config.services.klipper) group user;
      enable = true;
      address = "0.0.0.0";
      allowSystemControl = true; # power and systemd units
      settings = {
        machine = {
          validate_service = false;
        };
        server = {
          max_upload_size = 4096;
        };
        octoprint_compat = {};
        file_manager = {
          enable_object_processing = true;
          enable_config_write_access = false;
        };
        history = {};
        authorization = {
          cors_domains = [
            "${config.networking.hostName}"
            "*.local"
            "*.lan"
            "://localhost"
            "://localhost:*"
            "*://app.fluidd.xyz"
            "*://app.mainsail.xyz"
          ];
          trusted_clients = [
            "100.0.0.0/8"
            "10.0.0.0/8"
            "127.0.0.0/8"
            "169.254.0.0/16"
            "172.16.0.0/12"
            "192.168.0.0/16"
            "FE80::/10"
            "::1/128"
          ];
        };

      };
    };
    mainsail = {
      enable = true;
      nginx.extraConfig = ''
        client_max_body_size 256M;
      '';
    };
    cage = {
      inherit (config.services.klipper) user;
      enable = true;
      program = "${pkgs.klipperscreen}/bin/KlipperScreen" ;
      extraArguments = [
        "-dsm"
      ];
    };
    displayManager.autoLogin = {
      enable = true;
      inherit (config.services.klipper) user;
    };
    go2rtc = {
      enable = true;
      settings = {
        streams = {
          cam1 = "ffmpeg:device?video=/dev/video0&input_format=yuyv422&video_size=640x480#video=264#hardware";
        };
        webrtc = {
          listen = ":8555";
        };
      };
    };
  };

  systemd.services = {
    klipper = {
      preStart = mkForce ""; # Spams cfg copies
    };
    can-up = {
      description = "Auto bring up of the can interface";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.iproute2}/bin/ip link set can0 up";
        RemainAfterExit = "no";
      };
    };
  };

  environment = {
    systemPackages = attrValues {
      klipper = config.services.klipper.package;
    };
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

  system.activationScripts = {
    makeSDCardDir = {
      deps = [ "var" ];
      text = /* bash */ ''
        mkdir -p /var/lib/klipper /var/lib/moonraker/gcodes
        chown -R :klipper /var/lib/klipper /var/lib/moonraker
      '';
    };
  };

  users = {
    groups = {
      klipper = {};
    };
    users = {
      klipper = {
        group = "klipper";
        isNormalUser = true;
        extraGroups = [
          "klipper"
          "can"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    7125
    1984
    8555
  ];

}

{
  pkgs,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "tor" ["connectivity"] {
    services = {
      tor = {
        enable = true;
        torsocks.enable = true;
        # openFirewall = true;
        client = {
          enable = true;
          dns.enable = true;
        };
        settings = {
          DNSPort = [
            {
              addr = "127.0.0.1";
              port = 53;
            }
          ];
          CookieAuthentication = true;
          AvoidDiskWrites = 1;
          HardwareAccel = 1;
          SafeLogging = 1;
          NumCPUs = 1;
          ORPort = [443];
        };
      };
      privoxy = {
        enable = true;
        enableTor = true;
      };
      resolved = {
        enable = true;
        fallbackDns = [""];
      };
      networkd-dispatcher = {
        enable = true;
        rules."tor" = {
          onState = [
            "routable"
            "off"
          ];
          script = ''
            #!${pkgs.runtimeShell}
            if [[ $IFACE == "wlan0" && "''${AdministrativeState+set}" = "set" && $AdministrativeState == "configured" ]]; then
            echo "Restarting Tor ..."
            systemctl restart tor
            fi
            exit 0
          '';
        };
      };
    };

    networking.nameservers = ["127.0.0.1"];
  }

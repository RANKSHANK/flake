{
  config,
  lib,
  util,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (util) mkModule;
in
  mkModule "radicale" ["connectivity" "server"] {
    services.radicale = {
      enable = true;
      settings = let
        port = "5232";
      in {
        auth.type = "none";
        server = {
          hosts = [
            "0.0.0.0:${port}"
            "[::]:${port}"
            (mkIf config.modules.tailscale.enable "100.0.0.0:${port}")
          ];
        };
      };
      rights = {
        root = {
          user = ".+";
          collection = "";
          permissions = "R";
        };
        principal = {
          user = ".+";
          collection = "{user}";
          permissions = "RW";
        };
        calendars = {
          user = ".+";
          collection = "{user}/[^/]+";
          permissions = "rw";
        };
      };
    };
  }

{
  config,
  lib,
  pkgs,
  ...
}: let
  port = "42068";
  listenAddress = "localhost";
in
  lib.mkModule "gotify" ["server"] {
    services.gotify = {
      enable = true;
      environment = {
        GOTIFY_SERVER_PORT = port;
        GOTIFY_SERVER_LISTENADDR = listenAddress;
      };
    };
    webservices.gotify = "${listenAddress}:${port}";
  }

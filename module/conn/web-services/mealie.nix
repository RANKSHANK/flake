{
  lib,
  util,
  ...
}: let
  inherit (util) mkModule;
  port = 42067;
  listenAddress = "localhost";
in
  mkModule "mealie" ["server"] {
    services.mealie = {
      enable = true;
      inherit port listenAddress;
    };

    webservices.mealie = "${listenAddress}:${toString port}";
  }

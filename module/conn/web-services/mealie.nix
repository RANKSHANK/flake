{ lib, config, ... }: let
    port = 42067;
    listenAddress = "localhost";

in lib.mkModule "mealie" [ "server" ] {
    services.mealie = {
        enable = true;
        inherit port listenAddress;
    };

    webservices.mealie = "${listenAddress}:${toString port}";
}

{ lib, config, pkgs, ... }:

lib.mkModule "localsend" [ "connectivity" "sync" "desktop" ] {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) localsend;
    };

    networking.firewall = {
        allowedUDPPorts = [ 53317 ];
        allowedTCPPorts = [ 53317 ];
    };
}

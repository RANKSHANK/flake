{ lib, config, pkgs, ... }:

lib.mkModule "avahi" [ "connectivity" ] config {
    services = {

        avahi = {
            enable = true;
            nssmdns4 = true;
            nssmdns6 = true;
        };

        resolved = {
            enable = true;
        };

    };
}

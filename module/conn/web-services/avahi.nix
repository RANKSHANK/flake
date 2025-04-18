{ lib, ... }:

lib.mkModule "avahi" [ "connectivity" ] {
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

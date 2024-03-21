{ config, lib, pkgs, ... }:

lib.mkModule "dwarf-fortress" [ "desktop" "gaming" ] config {
    environment.systemPackages = builtins.attrValues {
        # inherit (pkgs) dwarf-fortress;
        inherit (pkgs.dwarf-fortress-packages) dwarf-fortress-full;
    };
}

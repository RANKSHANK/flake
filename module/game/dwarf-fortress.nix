{ config, lib, pkgs, ... }:

lib.mkModule "dwarf-fortress" [ "desktop" "gaming" ] {
    environment.systemPackages = builtins.attrValues {
        # inherit (pkgs) openal;
        inherit (pkgs.dwarf-fortress-packages)  dwarf-fortress-full;
    };
}

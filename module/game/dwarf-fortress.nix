{ config, lib, pkgs, ... }:

lib.mkModule "dwarf-fortress" [ "desktop" "gaming" ] config {
    environment.systemPackages = builtins.attrValues {
        # inherit (pkgs) openal;
        inherit (pkgs.dwarf-fortress-packages)  dwarf-fortress-full;
    };
}

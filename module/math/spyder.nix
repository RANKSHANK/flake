{ config, lib, pkgs, ... }:

lib.mkModule "spyder" [ "math" "desktop" ] {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) spyder;
    };
}

{ config, lib, pkgs, ... }:

lib.mkModule "spyder" [ "math" "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) spyder;
    };
}

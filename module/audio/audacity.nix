{ config, lib, pkgs, ... }:

lib.mkModule "audacity" [ "desktop" "audio" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) audacity;
    };
}

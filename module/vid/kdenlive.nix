{ config, lib, pkgs, ... }:

lib.mkModule "kdenlive" [ "desktop" "video" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) kdenlive;
    };
}

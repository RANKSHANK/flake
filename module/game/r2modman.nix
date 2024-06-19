{ config, lib, pkgs, ... }:

lib.mkModule "r2modman" [ "desktop" "gaming" ] config {

    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) r2modman;
    };
}

{ config, lib, pkgs, ... }:

lib.mkModule "r2modman" [ "desktop" "gaming" ] {

    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) r2modman;
    };
}

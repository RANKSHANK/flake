{ config, lib, pkgs, ... }:

lib.mkModule "pcmanfm" [ "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) pcmanfm;
    };
}

{ config, lib, pkgs, ... }:

lib.mkModule "unzip" [ "shell" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) unzip;
    };
}

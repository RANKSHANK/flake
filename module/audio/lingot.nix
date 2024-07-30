{ config, lib, pkgs, ... }:

lib.mkModule "lingot" [ "audio" "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) lingot;
    };
}

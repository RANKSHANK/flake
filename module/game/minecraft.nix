{ config, lib, pkgs, ... }:

lib.mkModule "minecraft" [ "gaming" "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) prismlauncher;
    };
}

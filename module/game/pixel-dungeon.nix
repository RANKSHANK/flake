{ config, lib, pkgs, ... }:

lib.mkModule "pixel-dungeon" [ "desktop" "gaming" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) shattered-pixel-dungeon; 
    };
}

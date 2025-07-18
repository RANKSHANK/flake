{ lib, config, pkgs, ... }:

lib.mkModule "cura" [ "desktop" "cad" ] {

    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) cura-appimage;
    };

}

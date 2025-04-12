{ lib, config, pkgs-stable, ... }:

lib.mkModule "cura" [ "desktop" "cad" ] {

    environment.systemPackages = builtins.attrValues {
        inherit (pkgs-stable) cura;

    };

}

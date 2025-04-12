{ lib, config, pkgs, ... }:

lib.mkModule "openscad" [ "desktop" "cad" ] {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) openscad;
    };
}

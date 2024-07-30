{ lib, config, pkgs, ... }:

lib.mkModule "openscad" [ "desktop" "cad" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) openscad;
    };
}

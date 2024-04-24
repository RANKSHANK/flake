{ lib, config, pkgs, ... }:

lib.mkModule "prusa" [ "desktop" "cad" ] config {

    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) prusa-slicer;
    };

}

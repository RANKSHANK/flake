{ lib, config, pkgs, ... }:

lib.mkModule "orca" [ "desktop" "cad" ] config {

    environment.systemPackages = builtins.attrValues {
        # inherit (pkgs) orca-slicer;
    };

}

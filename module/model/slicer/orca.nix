{ lib, config, pkgs, ... }:

lib.mkModule "orca" [ "desktop" "cad" ] {

    environment.systemPackages = builtins.attrValues {
        # inherit (pkgs) orca-slicer;
    };

}

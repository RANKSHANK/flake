{ lib, pkgs, ... }:

lib.mkModule "spyder" [ "math" "desktop" ] {

    environment.systemPackages = builtins.attrValues (let
        spyder = pkgs.spyder.overrideAttrs (final: prev: {
            propagatedBuildInputs = prev.propagatedBuildInputs ++ (builtins.attrValues {
                inherit (pkgs.python312Packages) spyder-kernels ipython;
            });
        });
    in {
        inherit spyder ;
    });
}

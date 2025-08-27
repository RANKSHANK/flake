{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "spyder" ["math" "desktop"] {
    environment.systemPackages = attrValues (let
      spyder = pkgs.spyder.overrideAttrs (final: prev: {
        propagatedBuildInputs =
          prev.propagatedBuildInputs
          ++ (attrValues {
            inherit (pkgs.python313Packages) spyder-kernels ipython;
          });
      });
    in {
      inherit spyder;
    });
  }

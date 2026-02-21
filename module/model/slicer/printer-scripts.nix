{
  inputs,
  pkgs,
  lib,
  util,
  ...
}: let
  inherit (util) mkModule;
  inherit (lib.attrsets) attrValues;
in
  mkModule "printer-scripts" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system})
        brick-layers
        mz-flow-temp-processor
      ;
    };
  }

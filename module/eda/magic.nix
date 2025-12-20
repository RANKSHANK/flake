{
  lib,
  pkgs,
  inputs,
  util,
  ...
}:
let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "magic" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      inherit (inputs.nix-stable.legacyPackages.${pkgs.system}) magic-vlsi;
    };
  }

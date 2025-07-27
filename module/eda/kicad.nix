{
  pkgs,
  inputs,
  lib,
  ...
}:
lib.mkModule "kicad" ["desktop" "cad"] {
  environment.systemPackages = builtins.attrValues {
    # inherit (pkgs) kicad;
    inherit (inputs.nix-stable.legacyPackages.${pkgs.system}) kicad; # OOM -_-
  };
}

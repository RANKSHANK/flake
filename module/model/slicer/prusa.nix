{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkModule "prusa" ["desktop" "cad"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) prusa-slicer;
  };
}

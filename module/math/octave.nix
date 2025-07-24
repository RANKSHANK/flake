{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkModule "octave" ["math" "desktop"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) octave;
    inherit (pkgs.octavePackages) symbolic;
  };
}

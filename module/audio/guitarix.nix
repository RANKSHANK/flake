{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkModule "guitarix" ["audio" "desktop"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) guitarix;
  };
}

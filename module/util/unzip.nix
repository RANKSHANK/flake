{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkModule "unzip" ["shell"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) unzip;
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkModule "pcmanfm" ["desktop"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) pcmanfm;
  };
}

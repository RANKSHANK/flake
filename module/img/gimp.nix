{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkModule "gimp" ["graphics" "desktop"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) gimp;
  };
}

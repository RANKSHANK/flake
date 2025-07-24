{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkModule "krita" ["graphics" "desktop"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) krita;
  };
}

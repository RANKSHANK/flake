{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkModule "appimage" ["repo" "desktop"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) appimage-run;
  };
}

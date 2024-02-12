{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "appimage" [ "repo" "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) appimage-run;
    };
}

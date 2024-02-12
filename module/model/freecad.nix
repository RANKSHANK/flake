{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "freecad" [ "desktop" "cad" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) freecad;
    };
}

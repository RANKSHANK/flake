{
  pkgs,
  lib,
  config,
  ...
}: lib.mkModule "kicad" [ "desktop" "cad" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) kicad;
    };
}

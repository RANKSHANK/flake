{
  lib,
  config,
  pkgs,
  ...
}: lib.mkModule "inkscape" [ "graphics" "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) inkscape-with-extensions;
    };
}

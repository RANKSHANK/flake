{
  lib,
  config,
  pkgs,
  ...
}: lib.mkModule "inkscape" [ "graphics" "desktop" ] {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) inkscape-with-extensions;
    };
}

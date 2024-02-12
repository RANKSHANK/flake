{
  lib,
  config,
  pkgs,
  ...
}: lib.mkModule "gimp" [ "graphics" "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) gimp;
    };
}

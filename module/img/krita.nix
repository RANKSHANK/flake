{
  lib,
  config,
  pkgs,
  ...
}: lib.mkModule "krita" [ "graphics" "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) krita;
    };
}

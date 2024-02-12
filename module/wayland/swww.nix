{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "swww" [ "desktop" "wayland" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) swww;
    };
}

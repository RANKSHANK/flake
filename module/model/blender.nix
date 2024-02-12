{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "blender" [ "cad" "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) blender;
    };
}

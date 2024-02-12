{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "rclone" [ "connectivity" "sync" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) rclone;
    };
}

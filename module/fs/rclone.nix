{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkModule "rclone" ["connectivity" "sync"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) rclone;
  };
}

{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "btop" [ "shell" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) btop;
    };
}

{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "bat" [ "shell" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) bat;
    };
}

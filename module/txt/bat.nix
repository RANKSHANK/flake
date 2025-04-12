{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "bat" [ "shell" ] {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) bat;
    };
}

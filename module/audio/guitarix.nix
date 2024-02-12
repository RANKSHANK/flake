{
  pkgs,
  lib,
  config,
  ...
}: lib.mkModule "guitarix" [ "audio" "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) guitarix;
    };
}

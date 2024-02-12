{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "yuzu" [ "gaming" "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) yuzu;
    };
}

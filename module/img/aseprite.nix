{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "aseprite" [ "desktop" "graphics" ] config {
    environment.systemPackages = builtins.attrValues {
      # inherit (pkgs) aseprite;
    };
}

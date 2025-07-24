{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkModule "aseprite" ["desktop" "graphics"] {
  environment.systemPackages = builtins.attrValues {
    # inherit (pkgs) aseprite;
  };
}

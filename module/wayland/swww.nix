{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkModule "swww" ["desktop" "wayland"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) swww;
  };
}

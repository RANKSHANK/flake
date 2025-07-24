{
  lib,
  pkgs,
  ...
}:
lib.mkModule "audacity" ["desktop" "audio"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) audacity;
  };
}

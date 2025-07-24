{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkModule "lingot" ["audio" "desktop"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) lingot;
  };
}

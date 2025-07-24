{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkModule "livecaptions" ["audio" "desktop"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) livecaptions;
  };
}

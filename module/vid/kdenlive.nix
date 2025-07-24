{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkModule "kdenlive" ["desktop" "video"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.kdePackages) kdenlive;
  };
}

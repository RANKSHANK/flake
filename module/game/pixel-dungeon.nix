{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkModule "pixel-dungeon" ["desktop" "gaming"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) shattered-pixel-dungeon;
  };
}

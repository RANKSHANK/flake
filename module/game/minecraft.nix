{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkModule "minecraft" ["gaming" "desktop"] {
  environment.systemPackages = builtins.attrValues {
    # inherit (pkgs) prismlauncher;
  };
}

{
  lib,
  pkgs,
  ...
}:
lib.mkModule "satisfactory-mod-manager" ["desktop" "gaming"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) satisfactorymodmanager;
  };
}

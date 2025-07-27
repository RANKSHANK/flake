{
  lib,
  pkgs,
  ...
}:
lib.mkModule "nvtop" ["shell" "desktop"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.nvtopPackages) full;
  };
}

{
  config,
  pkgs,
  lib,
  ...
}: lib.mkModule "protonvpn" [ "connectivity" "vpn" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) protonvpn-cli protonvpn-gui;
  };
}

{
  config,
  pkgs,
  lib,
  ...
}: lib.mkModule "protonvpn" [ "connectivity" "vpn" ] {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) protonvpn-cli protonvpn-gui;
  };
}

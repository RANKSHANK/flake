{ lib, config, pkgs, ... }:

lib.mkModule "signal" [ "desktop" "communication" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) signal-desktop;
    };
}

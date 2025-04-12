{ lib, config, pkgs, ... }:

lib.mkModule "signal" [ "desktop" "communication" ] {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) signal-desktop;
    };
}

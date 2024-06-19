{ lib, config, pkgs, ... }:

lib.mkModule "localsend" [ "connectivity" "sync" "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) localsend;
    };
}

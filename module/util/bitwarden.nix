{ lib, config, pkgs, ... }:

lib.mkModule "bitwarden" [ "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
        # inherit (pkgs) bitwarden;
    };
}

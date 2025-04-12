{ lib, config, pkgs, ... }:

lib.mkModule "bitwarden" [ "desktop" ] {
    environment.systemPackages = builtins.attrValues {
        # inherit (pkgs) bitwarden;
    };
}

{ lib, config, pkgs, ... }:

lib.mkModule "intellij" [ "desktop" ] {
    environment.systemPackages = builtins.attrValues {
        # inherit (pkgs.jetbrains) idea-community;
    };
}

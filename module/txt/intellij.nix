{ lib, config, pkgs, ... }:

lib.mkModule "intellij" [ "desktop" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs.jetbrains) idea-community;
    };
}

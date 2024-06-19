{ inputs, lib, config, pkgs, ... }:

lib.mkModule "cura" [ "desktop" "cad" ] config {

    environment.systemPackages = builtins.attrValues {
        # inherit (pkgs) cura;
        inherit (inputs.nix-stable.legacyPackages.${pkgs.system}) cura;

    };

}

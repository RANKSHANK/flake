{ lib, config, inputs, pkgs, ...}:

lib.mkModule "satisfactory-mod-manager" [ "desktop" "gaming" ] config {
    environment.systemPackages = builtins.attrValues {
        inherit (inputs.satisfactory-mod-pr.legacyPackages.${pkgs.system}) satisfactorymodmanager;
    };
}


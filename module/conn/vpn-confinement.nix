{ config, inputs, lib, pkgs, ... }:

lib.mkModule "vpn-confinement" [ "server" ] {
    imports = [
        inputs.vpn-confinement.nixosModules.default
    ];
}

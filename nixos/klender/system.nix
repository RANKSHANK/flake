{ config, lib, pkgs, inputs, ... }:

{
    imports = [
        "${pkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
    ];
}

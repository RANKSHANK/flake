{ config, inputs, lib, pkgs, ... }:

lib.mkModule "nvf" [ "shell" ] {
    imports = [
        inputs.nvf.nixosModules.default
    ];
    
}

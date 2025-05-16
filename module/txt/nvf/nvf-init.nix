{ inputs, pkgs, lib, ... }:

{
    imports = lib.listNixFilesRecursively ./plugin;

    vim = {
        package = inputs.neovim-nightly.packages.${pkgs.system}.neovim.overrideAttrs (final: prev: {
            # buildInputs = prev.buildInputs ++ (builtins.attrValues {
            #     inherit (pkgs) fd;
            # });
        });
        viAlias = false;
        vimAlias = false;
    };
    
}

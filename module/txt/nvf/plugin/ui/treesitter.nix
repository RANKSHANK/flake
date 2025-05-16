{ pkgs, ... }:

{
    vim = {
        treesitter = {
            enable = true;
            context.enable = true;
        };
        languages = {
            enableTreesitter = true;
        };
    };
}

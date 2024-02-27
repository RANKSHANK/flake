{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins = {
            comment-nvim = {
                enable = true;
            };
            todo-comments = {
                enable = true;
            };
        };
    };
}

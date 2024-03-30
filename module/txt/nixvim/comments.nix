{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins = {
            comment = {
                enable = true;
            };
            todo-comments = {
                enable = true;
            };
        };
    };
}

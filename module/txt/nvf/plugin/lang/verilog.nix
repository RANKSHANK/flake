{ config, pkgs, ... }:

{
    vim  = {
        languages = {
            verilog = {
                enable = true;
                lsp = {
                    enable = true;
                    server = "verible";
                };

            };
        };
    };
}

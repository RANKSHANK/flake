{ config, lib, ... }:

lib.mkModule "icons" [ "system" ] config {
    options = {
        icons = lib.mkOption {
            default = {
                search = "";
                diagnostics = {
                    error = "";
                    warn = "";
                    info = "";
                    hint = "󰌶";
                };
                fileStatus = {
                    modified = "󰳻";
                    readonly = "";
                    unnamed = "󱀶";
                    directory = "";
                };
                git = {
                    added = "";
                    modified = "󰦓";
                    removed = "";
                };
            };
            type = lib.types.attrs;
            description = "Text Icons";
        };
    };
}

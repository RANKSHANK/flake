{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) attrs;
in {
  options = {
    icons = mkOption {
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
      type = attrs;
      description = "Text Icons";
    };
  };
}

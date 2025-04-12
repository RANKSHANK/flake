{lib, config, ...}: let
  inherit (lib) mkOption;
in {
  options = {
    enabledModules = mkOption {
      default = [];
      type = lib.types.listOf lib.types.str;
      description = "Explicitly enabled modules";
    };

    disabledModules = mkOption {
      default = [];
      type = lib.types.listOf lib.types.str;
      description = "Explicitly disabled modules";
    };

    enabledTags = mkOption {
      default = [ "system" ];
      type = lib.types.listOf lib.types.str;
      description = "Tags used to enable modules and features";
    };

    keybinds = mkOption {
      default = [];
      type = lib.types.listOf lib.types.attrs;
      description = "Key combo set";
    };

    browsers = {
        homepage = mkOption {
            default = "";
            type = lib.types.str;
            description = "Default Homepage/ new tab page";
        };

        bookmarks = mkOption {
          default = [];
          type = lib.types.listOf lib.types.attrs;
          description = "Browser bookmarks";
        };

        searchEngines = mkOption {
          default = [];
          type = lib.types.listOf lib.types.attrs;
          description = "Browser search engines";
        };
    };

    exec = mkOption {
        default = [];
        type = lib.types.listOf lib.types.str;
    };

    monitors = mkOption {
      default = {};
      type = lib.types.attrs;
      description = "Sets representing monitor information";
    };

  };
}

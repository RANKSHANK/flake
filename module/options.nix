{lib, config, ...}: lib.mkModule "options" [ "system" ] config {
  options = {
    enabledModules = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.str;
      description = "Explicitly enabled modules";
    };

    disabledModules = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.str;
      description = "Explicitly disabled modules";
    };

    enabledTags = lib.mkOption {
      default = [ "system" ];
      type = lib.types.listOf lib.types.str;
      description = "Tags used to enable modules and features";
    };

    keybinds = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.attrs;
      description = "Key combo set";
    };

    browsers = {
        homePage = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "Default Homepage/ new tab page";
        };

        bookmarks = lib.mkOption {
          default = [];
          type = lib.types.listOf lib.types.str;
          description = "Browser bookmarks";
        };

        searchEngines = lib.mkOption {
          default = [];
          type = lib.types.listOf lib.types.attrs;
          description = "Browser search engines";
        };
    };

    monitors = lib.mkOption {
      default = {};
      type = lib.types.attrs;
      description = "Sets representing monitor information";
    };

  };
}

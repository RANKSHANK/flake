{
  lib,
  util,
  ...
}: let
  inherit (lib.modules) mkDefault;
  inherit (lib.options) mkOption;
  inherit (lib.strings) replaceStrings;
  inherit (lib.trivial) readFile;
  inherit (lib.types) attrs attrsOf listOf str;
  inherit (util) isDecrypted ternary;
in {
  options = {
    termInit = mkOption {
      default = [];
      type = listOf str;
      description = "Commands to run on terminal init";
    };

    enabledModules = mkOption {
      default = [];
      type = listOf str;
      description = "Explicitly enabled modules";
    };

    disabledModules = mkOption {
      default = [];
      type = listOf str;
      description = "Explicitly disabled modules";
    };

    enabledTags = mkOption {
      default = ["system"];
      type = listOf str;
      description = "Tags used to enable modules and features";
    };

    keybinds = mkOption {
      default = [];
      type = listOf attrs;
      description = "Key combo set";
    };

    browsers = {
      homepage = mkOption {
        default = "";
        type = str;
        description = "Default Homepage/ new tab page";
      };

      bookmarks = mkOption {
        default = [];
        type = listOf attrs;
        description = "Browser bookmarks";
      };

      searchEngines = mkOption {
        default = [];
        type = listOf attrs;
      };
    };

    exec = mkOption {
      default = [];
      type = listOf str;
    };

    exec-once = mkOption {
      default = [];
      type = listOf str;
    };

    monitors = mkOption {
      default = {};
      type = attrs;
      description = "Sets representing monitor information";
    };

    webservices = mkOption {
      default = {};
      type = attrsOf str;
      description = "Attrs of web services for reverse proxying";
    };

    baseURL = mkOption {
      type = str;
      description = "Ending of the URL for the server";
    };
  };

  config = {
    baseURL = mkDefault (ternary isDecrypted (replaceStrings ["\n"] [""] (readFile ./domain.crypt.txt)) "local");
  };
}

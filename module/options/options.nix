{lib, config, ...}: let
  inherit (lib) mkOption;
in {

  options = {

    decrypted = mkOption {
        default = false;
        type = lib.types.bool;
        description = "Decryption flag"; 
    };
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

    webservices = mkOption {
        default = {}; 
        type = lib.types.attrsOf lib.types.str;
        description = "Attrs of web services for reverse proxying";
    };

    url-head = mkOption {
        type = lib.types.str; 
        description = "Beginning of the URL for the server";
    };

    url-tail = mkOption {
        type = lib.types.str; 
        description = "Ending of the URL for the server";
    };

  };

  config = {

    decrypted = let 
        file = ../../${builtins.replaceStrings [ "#SALT#" "\n" ]  [ "" "" ] (builtins.readFile ../../.crypted.crypt.txt)};
    in builtins.isPath file && builtins.pathExists file;

    url-head = lib.mkDefault config.networking.hostName;

    url-tail = lib.mkDefault (lib.ternary config.decrypted (builtins.readFile ./domain.crypt.txt) "local");
  };


}

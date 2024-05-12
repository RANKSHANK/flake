{
  config,
  lib,
  pkgs,
  user,
  ...
}:
lib.mkModule "firefox" [ "connectivity" "desktop" ] config {
    home-manager.users.${user} = {
      programs.firefox = {
        enable = true;
        package = pkgs.wrapFirefox pkgs.firefox.unwrapped {
          nativeMessagingHosts = builtins.attrValues {
            # inherit (pkgs) tridactyl-native;
          };
          extraPolicies = {
            DirectDownloadDirectory = "$XDG_DOWNLOAD_DIR";
            DisableFirefoxStudies = true;
            DisableTelemetry = true;
            DisableFirefoxAccounts = false;
            DisablePocket = false;
            FirefoxHome = {
              Pocket = false;
              Snippets = false;
            };
            UserMessaging = {
              ExtensionReccomendations = false;
              SkipOnboarding = true;
            };
            gdkWayland = true;
          };
        };
        policies = {
            ExtensionSettings = let
                latest = str: "https://addons.mozilla.org/firefox/downloads/latest/${str}/latest.xpi";
          in
            builtins.mapAttrs (name: attrs: attrs // {installation_mode = "force_installed";}) {
              # "tridactyl.vim@cmcaine.co.uk" = {
              #   install_url = latest "tridactyl-vim";
              # };
            };
        };
        profiles.${user} = {
          extensions = builtins.attrValues {
            # inherit (config.nur.repos.rycee.firefox-addons) bypass-paywalls-clean;
          };
          id = 0;
          isDefault = true;
          name = "${user}";
          settings = import ./userprefs.nix config user;
          search = {
            force = true;
            engines = builtins.listToAttrs (builtins.map (entry: {
                name = entry.name;
                value = {
                  urls = [
                    {
                      template = builtins.replaceStrings ["{}"] ["{searchTerms}"] entry.url;
                    }
                  ];
                  definedAliases = [
                    "!${entry.shortcut}"
                  ];
                  updateIterval = 24 * 60 * 60 * 1000;
                  iconUpdateUrl = lib.mkIf (lib.safeIsString "icon" entry) entry.icon;
                };
              })
              config.browsers.searchEngines);
            default = "${(lib.head config.browsers.searchEngines).name}";
            order = map (attrs: attrs.name) config.browsers.searchEngines;
          };
          extraConfig = ''
          '';
          userChrome = import ./userchrome.nix config lib;
        };
      };

      xdg.configFile."tridactyl/tridactylrc".text = import ./tridactylrc.nix config user lib;

      xdg.configFile."tridactyl/themes/nix.css".text = import ./tridactylchrome.nix config;

      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        MOZ_ACCELERATED = 1;
        MOZ_WEBRENDER = 1;
      };
  };
}

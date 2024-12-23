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
        profiles.${user} = let
            inherit (config.stylix) fonts;
            inherit (config.lib.stylix) colors;
            genCSS = dir: lib.concatStrings (lib.flatten [
                '':root {
                    --hide-delay: 300ms;
                    --hide-duration: 32ms;
                    --tab-active-bg-color: #${colors.base02};
                    --tab-inactive-bg-color: #${colors.base00};
                    --tab-active-fg-fallback-color: #${colors.base05};
                    --tab-inactive-fg-fallback-color: #${colors.base05};
                    --urlbar-bg-focused: #${colors.base04};
                    --urlbar-fg-focused: #${colors.base06};
                    --urlbar-bg-unfocused: #${colors.base00};
                    --urlbar-fg-unfocused: #${colors.base05};
                    --toolbar-bgcolor: #${colors.base00} !important;
                    --urlbar-font: '${fonts.monospace.name}';
                    --tab-border-radius: 15px !important;
                    --tab-border: 8;
                    --tab-height: 25;
                    --tab-font: '${fonts.monospace.name}';
                    --navbar-width: 40; 
                    --navbar-height-mini: calc(var(--tab-height) + var(--tab-border));
                    --navbar-hide-distance: calc(var(--tab-height) * 2);
                }''
                (map (builtins.readFile) (lib.listTargetFilesRecursively ".css" dir))
          ]);
        in {
          extensions = builtins.attrValues {
            # inherit (pkgs.nur.repos.rycee.firefox-addons) bypass-paywalls-clean;
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
          # extraConfig = ''
          # '';
          userContent = genCSS ./usercontent;
          userChrome = genCSS ./userchrome;
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

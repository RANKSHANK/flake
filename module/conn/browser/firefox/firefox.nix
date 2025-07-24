{
  config,
  lib,
  pkgs,
  user,
  ...
}:
lib.mkModule "firefox" ["connectivity" "desktop"] {
  home-manager.users.${user} = {
    xdg.mimeApps = {
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };
    stylix.targets.firefox.profileNames = [user];
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox.unwrapped {
        nativeMessagingHosts = builtins.attrValues {
          inherit (pkgs) tridactyl-native;
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
      profiles.${user} = let
        inherit (config.stylix) fonts;
        inherit (config.lib.stylix) colors;
        genCSS = dir:
          lib.concatStrings (lib.flatten [
            ''              :root {
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
                                  --base00: #${colors.base00}
                                  --base01: #${colors.base01}
                                  --base02: #${colors.base02}
                                  --base03: #${colors.base03}
                                  --base04: #${colors.base04}
                                  --base05: #${colors.base05}
                                  --base06: #${colors.base06}
                                  --base07: #${colors.base07}
                                  --base08: #${colors.base08}
                                  --base09: #${colors.base09}
                                  --base0A: #${colors.base0A}
                                  --base0B: #${colors.base0B}
                                  --base0C: #${colors.base0C}
                                  --base0D: #${colors.base0D}
                                  --base0E: #${colors.base0E}
                                  --base0F: #${colors.base0F}
                                  }''
            (map (builtins.readFile) (lib.listTargetFilesRecursively ".css" dir))
          ]);
      in {
        extensions = {
          force = true;
          packages = builtins.attrValues {
            inherit
              (pkgs.nur.repos.rycee.firefox-addons)
              # bypass-paywalls-clean
              tridactyl
              ublock-origin
              darkreader
              bitwarden
              temporary-containers
              multi-account-containers
              ;
          };
          settings = {
            "{c607c8df-14a7-4f28-894f-29e8722976af}" = {
              #temporary-containers
              force = true;
              settings = {
                preferences = {
                  automaticMode = {
                    active = true;
                  };
                  container = {
                    namePrefix = "";
                    color = "red";
                    icon = "fence";
                    numberMode = "reuse";
                  };
                  isolation = {
                    global = {
                      navigation.targetDomain = "notsamedomain";
                    };
                  };
                };
              };
            };
          };
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
        userContent = genCSS ./usercontent;
        userChrome = genCSS ./userchrome;
        containersForce = true;
        containers = {
          google = {
            icon = "fingerprint";
            color = "green";
            id = 0;
          };
          microsoft = {
            icon = "fingerprint";
            color = "green";
            id = 1;
          };
          yahoo = {
            icon = "fingerprint";
            color = "green";
            id = 2;
          };
          uni = {
            icon = "briefcase";
            color = "blue";
            id = 3;
          };
          shopping = {
            icon = "cart";
            color = "orange";
            id = 4;
          };
        };
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

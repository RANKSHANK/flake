{
  config,
  lib,
  pkgs,
  user,
  ...
}: let
  colors = config.lib.stylix.colors;
  font = config.stylix.fonts;
in lib.mkModule "firefox" [ "connectivity" "desktop" ] config {
    home-manager.users.${user} = {
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
        policies = {
            ExtensionSettings = let
                latest = str: "https://addons.mozilla.org/firefox/downloads/latest/${str}/latest.xpi";
          in
            builtins.mapAttrs (name: attrs: attrs // {installation_mode = "force_installed";}) {
              "tridactyl.vim@cmcaine.co.uk" = {
                install_url = latest "tridactyl-vim";
              };
            };
        };
        profiles.${user} = {
          id = 0;
          isDefault = true;
          name = "${user}";
          settings = import ./userprefs.nix user;
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

      xdg.configFile."tridactyl/tridactylrc".text = ''
      '';
      xdg.configFile."tridactyl/themes/${user}.css".text = with colors; ''
:root { 
    --base00: #${base00};
    --base01: #${base01};
    --base02: #${base02};
    --base03: #${base03};
    --base04: #${base04};
    --base05: #${base05};
    --base06: #${base06};
    --base07: #${base07};
    --base08: #${base08};
    --base09: #${base09};
    --base0A: #${base0A};
    --base0B: #${base0B};
    --base0C: #${base0C};
    --base0D: #${base0D};
    --base0E: #${base0E};
    --base0F: #${base0F};
    --font: "${font.monospace.name}";

    --tridactyl-fg: var(--base05);
    --tridactyl-bg: var(--base00);
    --tridactyl-url-fg: var(--base08);
    --tridactyl-url-bg: var(--base00);
    --tridactyl-highlight-box-bg: var(--base0B);
    --tridactyl-highlight-box-fg: var(--base00);
    --tridactyl-cmdl-font-family: var(--font);
    --tridactyl-cmplt-font-family: var(--font);
    --tridactyl-hintspan-font-family: var(--font);
    --tridactyl-hintspan-font-size: ${toString font.sizes.popups}pt;


    /* Hint character tags */
    --tridactyl-hintspan-fg: var(--base00) !important;
    --tridactyl-hintspan-bg: var(--base0A) !important;

    /* Element Highlights */
    --tridactyl-hint-active-fg: none;
    --tridactyl-hint-active-bg: none;
    --tridactyl-hint-active-outline: none;
    --tridactyl-hint-bg: none;
    --tridactyl-hint-outline: none;
}

#command-line-holder {    
    order: 1;
    border: 2px solid var(--base0B);
    color: var(--tridactyl-bg);
}

#tridactyl-input {    
    padding: 1rem;
    color: var(--tridactyl-fg);
    width: 90%;
    font-size: 1.5rem;
    line-height: 1.5;
    background: var(--tridactyl-bg);
    padding-left: unset;
    padding: 1rem;
}

#completions table {    
    font-size: 0.8rem;
    font-weight: 200;
    border-spacing: 0;
    table-layout: fixed;
    padding: 1rem;
    padding-top: 1rem;
    padding-bottom: 1rem;
}

#completions > div {    
    max-height: calc(20 * var(--option-height));
    min-height: calc(10 * var(--option-height));
}

/* COMPLETIONS */

#completions {    
    --option-height: 1.4em;
    color: var(--tridactyl-fg);
    background: var(--tridactyl-bg);
    display: inline-block;
    font-size: ${toString font.sizes.popups}pt;
    font-weight: 200;
    overflow: hidden;
    width: 100%;
    border-top: unset;
    order: 2;
}

#completions .HistoryCompletionSource {
    max-height: unset;
    min-height: unset;
}

#completions .HistoryCompletionSource table {    
    width: 100%;
    font-size: ${toString font.sizes.popups}pt;
    border-spacing: 0;
    table-layout: fixed;
}

/* redundancy 2: redundancy 2: more redundancy */
#completions .BmarkCompletionSource {    
    max-height: unset;
    min-height: unset;
}

#completions table tr td.prefix,#completions table tr td.privatewindow,#completions table tr td.container,#completions table tr td.icon {    
    display: none;
}

#completions .BufferCompletionSource table {    
    width: unset;
    font-size: ${toString font.sizes.popups}pt;
    border-spacing: unset;
    table-layout: unset;
}

#completions table tr .title {    
    width: 50%;
}

#completions table tr {    
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

#completions .sectionHeader {    
    background: unset;
    font-weight: 200;
    border-bottom: unset;
    padding: 1rem !important;
    padding-left: unset;
    padding-bottom: 0.2rem;
}

#cmdline_iframe {    
    position: fixed !important;
    bottom: unset;
    top: 25% !important;
    left: 10% !important;
    z-index: 2147483647 !important;
    width: 80% !important;
    box-shadow: rgba(0, 0, 0, 0.5) 0px 0px 20px !important;
}

.TridactylStatusIndicator {    
    position: fixed !important;
    bottom: 0 !important;
    background: var(--tridactyl-bg) !important;
    /* border: unset !important;
    border: 1px var(--base0B) solid !important; */
    font-size: ${toString (font.sizes.popups)}pt !important;
    padding: 1pt !important;
}

#completions .focused {    
    background: var(--base0B);
    color: var(--base00);
}

#completions .focused .url {    
    background: var(--base0B);
    color: var(--base00);
}

#Ocean-normal { */
 border-color: green !important; */
} */

#Ocean-insert { */
 border-color: yellow !important; */
} */
'';

      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        MOZ_ACCELERATED = 1;
        MOZ_WEBRENDER = 1;
      };
  };
}

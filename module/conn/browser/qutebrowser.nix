{
  pkgs,
  user,
  config,
  lib,
  util,
  ...
}: let
  inherit (lib) listToAttrs;
  inherit (util) mkModule;
in
  mkModule "qutebrowser" ["desktop" "connectivity"] {
    home-manager.users.${user} = {
      programs.qutebrowser = {
        enable = true;
        package = pkgs.qutebrowser.override {
          withPdfReader = false;
        };
        searchEngines =
          {
            DEFAULT = (lib.head config.browsers.searchEngines).url;
          }
          // (listToAttrs (map (attrs: {
              name = "!${attrs.shortcut}";
              value = "${attrs.url}";
            })
            config.browsers.searchEngines));
        extraConfig = let
          stylixCss = pkgs.writeText "stylixCss.css" ''

          '';
        in ''
          c.url.start_pages = ['${config.browsers.homepage}'];
          c.hints.selectors["code"] = [
            #Selects all code tags where parent != pretage
            ":not(pre) > code",
            "pre"
          ];
          c.colors.webpage.darkmode.enabled=True;
          config.set('colors.webpage.preferred_color_scheme', 'dark');
          config.set('content.user_stylesheets', '${stylixCss}');
        '';
        keyBindings = {
          normal = {
            ",v" = let
              hintMpv = pkgs.writeShellScript "mpv_queue" ''
                #!/bin/bash
                file=$*
                if [[ $(pgrep umpv) ]] && [[ -S /tmp/mpv.socket ]]; then
                  echo "loadfile \"''${file}\" append-play" | socat - /tmp/mpv.socket
                else
                  rm -f /tmp/mpv.socket
                  umpv --name=queue --title=queue --input-ipc-server=/tmp/mpv.socket --no-terminal --force-window=yes "$file" &
                  fi
              '';
            in "hint links spawn --verbose --detach ${hintMpv} {hint-url}";
            ",c" = let
              hintCode = pkgs.fetchurl {
                url = "https:/raw.githubusercontent.com/LaurenceWarne/qute-code-hint/master/code_select.py";
                hash = "sha256-HBIBilAqp/20jG0jlGruzpaMhszaLfP3O3tWizisKOg=";
              };
              wrapCode = pkgs.writeShellScript "wrapCodeHints" ''
                #!/usr/bin/env nix-shell
                #!nix-shell -i python3 -p "python3.withPackages(ps: [ ps.tldextract ps.pyperclip])"
                python3 ${hintCode}
              '';
            in "hint code userscript ${wrapCode}";
          };
        };
      };
    };
  }

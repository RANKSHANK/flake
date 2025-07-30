{
  pkgs,
  user,
  lib,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.modules) mkDefault;
  inherit (util) mkModule;
in
  mkModule "xdg" [] {
    systemd = {
      timers.user-tmp-clean = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };

      services.user-tmp-clean = {
        serviceConfig.Type = "oneshot";
        script = ''
          target="/home/${user}/tmp"
          dump="/tmp/${user}_old/"
          days=14
          removed=$(find "$target" -type f,d -mtime +$days -print)
          if [[ -n "$removed" ]]; then
              mkdir $dump
              find "$target" -type f,d -mtime +$days -exec mv '{}' "$dump" \;
              if command -v notify-send &> /dev/null; then
                  count=$(echo "$removed_items" | wc -l)
                  title="$target $count files cleaned:"
                  body="\n$removed"
                  notify-send "$title" "$body"
              fi
          fi
        '';
      };
    };

    xdg = {
      portal = {
        enable = true;
        extraPortals = attrValues {
          inherit
            (pkgs)
            xdg-desktop-portal-gtk
            ;
        };
        config = {
          common.default = mkDefault "*";
        };
      };
    };
    home-manager.users.${user}.xdg = {
      mimeApps.enable = true;
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "$HOME/.cache/desktop";
        documents = "$HOME/documents";
        download = "$HOME/tmp";
        music = "$HOME/audio";
        pictures = "$HOME/images";
        videos = "$HOME/video";
        templates = null;
        publicShare = null;
        extraConfig = {
          XDG_PROJ_DIR = "$HOME/projects";
          XDG_MISC_DIR = "$HOME/misc";
        };
      };
    };
  }

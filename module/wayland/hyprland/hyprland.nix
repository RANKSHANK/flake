{
  config,
  inputs,
  lib,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.lists) flatten;
  inherit (lib.modules) mkForce mkIf;
  inherit (lib.strings) toInt;
  inherit (util) mkModule;

  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (config.lib.stylix) colors;
  opacity = config.stylix.opacity.desktop;
in
  mkModule "hyprland" [] {
    imports = [
      ./keybinds.nix
    ];

    services.greetd = {
      enable = true;
      settings = rec {
        # Skip the login screen because luks
        initial_session = {
          command = "dbus-launch --sh-syntax --exit-with-session start-hyprland";
          user = "${user}";
        };
        default_session = initial_session;
      };
    };

    environment = {
      variables = {
        XDG_CURRENT_DESKTOP = "hyprland";
        # WLR_BACKEND = "vulkan";
        NVD_BACKEND = "direct";
        LIBVA_DRIVER_NAME = mkIf config.modules.nvidia-gpu.enable "nvidia";
        __GL_GSYNC_ALLOWED = "1";
        __GL_VRR_ALLOWED = "0";
        AQ_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1";
      };

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        GDK__BACKEND = mkIf config.modules.nvidia-gpu.enable "nvidia-drm";
        # GBM_BACKEND = mkIfEnabled "nvidia-gpu" config "nvidia-drm";
        # WLR_NO_HARDWARE_CURSORS = "1";
      };

      systemPackages = attrValues {
        inherit
          (pkgs)
          nwg-displays
          swaylock
          swayidle
          ;
        inherit
          (inputs.hyprland.packages.${system})
          xdg-desktop-portal-hyprland
          ;
      };
    };

    security.pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
    programs = {
      xwayland.enable = true;
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${system}.hyprland;
      };
    };

    home-manager.users.${user} = {
      stylix.targets.hyprpaper.enable = mkForce false;
      services.hyprpaper.enable = mkForce false;
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;

        systemd = {
          enable = true;
          variables = ["--all"];
          extraCommands = [
            "systemctl --user stop graphical-session.target"
            "systemctl --user start hyprland-session.target"
          ];
        };

        package = inputs.hyprland.packages.${system}.hyprland;

        plugins = pkgs.callPackage ./plugins.nix {inherit inputs util;};

        settings = {
          inherit (config) exec;

          exec-once = flatten [
            "sleep 1; killall -e xdg-desktop-portal-hyprland; killall -e xdg-desktop-portal-wlr; killall xdg-desktop-portal; /usr/lib/xdg-desktop-portal-hyprland &; sleep 2; \usr\lib\xdg-desktop-portal"
            "$systemctl --user start ${pkgs.hyprpolkitagent}/bin/hyprpolkitagent"
            # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            config.exec-once
          ];

          source = [
            "~/.config/hypr/monitors.conf"
            "~/.config/hypr/workspaces.conf"
          ];

          general = {
            border_size = 0;
            gaps_in = 0;
            gaps_out = 0;
            layout = "dwindle";
          };
          render = {
            # explicit_sync = false;
          };

          cursor = {
            no_hardware_cursors = true;
            use_cpu_buffer = 1;
          };

          decoration = {
            rounding = 0;
            active_opacity = opacity;
            inactive_opacity = opacity;
            fullscreen_opacity = opacity;
            blur = {
              enabled = true;
            };
            screen_shader =
              (pkgs.writeText "hyprland-shader" (
                pkgs.callPackage
                ./shaders/balatro.nix
                {
                  inherit config inputs util;
                }
              )).outPath;
          };

          animations = {
            enabled = true;
            bezier = [
              "move, 0.1, 0.7, 0.1, 1.05"
              "border,  0, 0, 1, 1"
              "focusIn, 1, -0.07, -0.1, 0.95"
              "focusOut, 1, -0.07, -0.1, 0.95"
            ];
            animation = [
              "windows,1,0.25,move"
              "windowsOut,1,0.25,default,popin 60%"
              "windowsMove,1,0.25,move"
              "borderangle,1,100,border,loop"
              "hyprfocusIn, 1, 0.25, focusIn"
              "hyprfocusOut, 1, 0.25, focusOut"
            ];
          };

          input = {
            kb_layout = "us";
            kb_options = [
              "caps:escape"
            ];
            follow_mouse = 2;
            mouse_refocus = false;
            repeat_delay = 250;
            numlock_by_default = true;
            accel_profile = "flat";
            sensitivity = 1.0;
            touchpad = {
              natural_scroll = true;
              middle_button_emulation = true;
              tap-to-click = true;
            };
          };

          gestures = {
            # workspace_swipe = true;
            # workspace_swipe_fingers = 3;
            workspace_swipe_distance = 100;
          };

          dwindle = {
            pseudotile = true;
            force_split = 2;
          };

          debug = {
            disable_logs = true;
            damage_tracking = 0;
          };

          misc = {
            vrr = 1;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            disable_xdg_env_checks = true;
            animate_mouse_windowdragging = true;
          };

          windowrule = [
            "border_size 0, match:workspace 1, match:float 0, match:title ^.*(-\\sYouTube\\s—).*$"
            "border_size 0, match:float 0, match:focus 1, match:initial_class ^.*(steam_app_\\d+)$"
            "border_size 2, match:float 1"
            "rounding 8, match:float 1"
            "border_color rgba(${colors.base05}22) rgba(${colors.base05}22) rgba(${colors.base05}ff) rgba(${colors.base05}44) rgba(${colors.base05}22), match:focus 1"
            "float 1, match:title ^.*(Picture-in-Picture).*$"
            "pin 1, match:title ^.*(Picture-in-Picture).*$"
            "size 30% 30%, match:title ^.*(Picture-in-Picture).*$"
            "move 70% 70%, match:title ^.*(Picture-in-Picture).*$"
          ];

          plugin = {
            hyprfocus = {
              mode = "bounce";
              bounce_strength = 0.98;
              fade_opacity = 0.2;
            };
            easymotion = let
              pixels = config.stylix.fonts.sizes.applications;
            in {
              textsize = 4 * pixels;
              textcolor = "rgba(${colors.base0D}FF)";
              bgcolor = "rgba(${colors.base01}FF)";
              bordercolor = "rgba(${colors.base01}FF)";
              bordersize = pixels;
              rounding = pixels;
              motionkeys = "wfpgarstdzxcvb";
              motionlabels = "WFPGARSTDZXCVB";
            };
          };
        };
      };
    };
  }

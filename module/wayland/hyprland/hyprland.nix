{
  config,
  inputs,
  pkgs,
  user,
  lib,
  ...
}: let
  opacity = config.stylix.opacity.desktop;
  colors = config.lib.stylix.colors;
in lib.mkModule "hyprland" [] config {
    xdg.portal.config.common.default = lib.mkForce "xdg-desktop-portal-hyprland";

    services.greetd = {
      enable = true;
      settings = rec {
        # Skip the login screen because luks
        initial_session = {
          command = "Hyprland";
          user = "${user}";
        };
        default_session = initial_session;
      };
    };

    environment = {
      variables = {
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        WLR_BACKEND = "vulkan";
        LIBVA_DRIVER_NAME = lib.mkIfEnabled "nvidia-gpu" config "nvidia";
        __GL_GSYNC_ALLOWED = "1";
        __GL_VRR_ALLOWED = "0";
      };

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        GDK__BACKEND = lib.mkIfEnabled "nvidia-gpu" config "nvidia-drm";
        WLR_NO_HARDWARE_CURSORS = "1";
      };

      systemPackages = builtins.attrValues {
        inherit (pkgs) swaylock swayidle wlr-randr;
      };
    };

    security.pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };

    home-manager.users.${user}.wayland.windowManager.hyprland = {
      enable = true;

      package = inputs.hyprland.packages.${pkgs.system}.hyprland;

      settings = {
        general = {
          border_size = 3;
          gaps_in = 3;
          gaps_out = 3;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          active_opacity = opacity;
          inactive_opacity = opacity;
          fullscreen_opacity = opacity;
          drop_shadow = true;
          blur = {
            enabled = true;
          };
        };

        animations = {
          enabled = true;
          bezier = [
            "move, 0.1, 0.7, 0.1, 1.05"
            "border,  0, 0, 1, 1"
          ];
          animation = [
            "windows,1,7,move"
            "windowsOut,1,3,default,popin 60%"
            "windowsMove,1,7,move"
            "borderangle,1,100,border,loop"
          ];
        };

        input = {
          kb_layout = "us";
          kb_options = [
            "caps:escape"
          ];
          follow_mouse = 3;
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
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
          workspace_swipe_distance = 100;
        };

        dwindle = {
          pseudotile = true;
          force_split = 2;
          no_gaps_when_only = 2;
        };

        misc = {
          vrr = 2;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          animate_mouse_windowdragging = true;
        };

        windowrulev2 = [
          "bordercolor rgba(${colors.base0A}22) rgba(${colors.base0A}22) rgba(${colors.base0A}ff) rgba(${colors.base0A}44) rgba(${colors.base0A}22), focus:1"
          "bordersize 1, focus:1, fullscreen:0"
          "noborder, focus:1, fullscreen:1"
          "rounding 5, focus:1"
          "rounding 0, xwayland:1, floating:1, focus:1"
        ];

        exec = [
          "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1"
        ];
      };
    };
}
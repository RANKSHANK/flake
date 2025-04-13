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
in lib.mkModule "hyprland" [] {

    imports = [
        ./keybinds.nix
        ./monitors.nix
    ];

    # xdg.portal.config.common.default = lib.mkForce "xdg-desktop-portal-hyprland";

    services.greetd = {
      enable = true;
      settings = rec {
        # Skip the login screen because luks
        initial_session = {

          command = "dbus-launch --sh-syntax --exit-with-session Hyprland";
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
        LIBVA_DRIVER_NAME = lib.mkIf config.modules.nvidia-gpu.enable "nvidia";
        __GL_GSYNC_ALLOWED = "1";
        __GL_VRR_ALLOWED = "0";
      };

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        GDK__BACKEND = lib.mkIf config.modules.nvidia-gpu.enable "nvidia-drm";
        # GBM_BACKEND = lib.mkIfEnabled "nvidia-gpu" config "nvidia-drm";
        # WLR_NO_HARDWARE_CURSORS = "1";
      };

      systemPackages = builtins.attrValues {
        inherit (pkgs)
            swaylock
            swayidle
        ;
        inherit (inputs.hyprland.packages.${pkgs.system}) 
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
            package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        };
    };

    home-manager.users.${user} = {
        stylix.targets.hyprland.enable = false;
        wayland.windowManager.hyprland = {
            enable = true;
            xwayland.enable = true;

            systemd = {
                variables = [ "--all" ];
                extraCommands = [
                    "systemctl --user stop graphical-session.target"
                    "systemctl --user start hyprland-session.target"
                ];
            };

            package = inputs.hyprland.packages.${pkgs.system}.hyprland;

            settings = {
                exec-once = [
                    "sleep 1; killall -e xdg-desktop-portal-hyprland; killall -e xdg-desktop-portal-wlr; killall xdg-desktop-portal; /usr/lib/xdg-desktop-portal-hyprland &; sleep 2; \usr\lib\xdg-desktop-portal"
                    "$systemctl --user start ${pkgs.hyprpolkitagent}/bin/hyprpolkitagent"
                    # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                    # "pw-loopback"
                    
                ];
                general = {
                    border_size = 3;
                    gaps_in = 3;
                    gaps_out = 3;
                    layout = "dwindle";
                };
                render = {
                    explicit_sync = false;
                };

                cursor = {
                    no_hardware_cursors = true;
                    use_cpu_buffer = true;
                };

                decoration = {
                    rounding = 10;
                    active_opacity = opacity;
                    inactive_opacity = opacity;
                    fullscreen_opacity = opacity;
                    # drop_shadow = true;
                    blur = {
                        enabled = true;
                    };
                    screen_shader = "/home/${user}/.config/hypr/shader.frag";
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
                    workspace_swipe = true;
                    workspace_swipe_fingers = 3;
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
                    background_color = "rgba(${colors.base00}ff)"; 
                };

                windowrulev2 = [
                    "bordersize 1, focus:1, fullscreen:0"
                    "noborder, focus:1, fullscreen:1"
                    "noborder,onworkspace:1,floating:0,title:^.*(-\\sYouTube\\s—).*$"
                    "noborder, floating:0, focused:1, initialClass:^.*(steam_app_\\d+)$"
                    "bordercolor rgba(${colors.base0A}22) rgba(${colors.base0A}22) rgba(${colors.base0A}ff) rgba(${colors.base0A}44) rgba(${colors.base0A}22), focus:1"
                    "rounding 5, focus:1"
                    "rounding 0, xwayland:1, floating:1, focus:1"
                    "float, title:^.*(Picture-in-Picture).*$"
                    "pin, title:^.*(Picture-in-Picture).*$"
                    "size 30% 30%, title:^.*(Picture-in-Picture).*$"
                    "move 70% 70%, title:^.*(Picture-in-Picture).*$"

                ];

                exec = config.exec;

            };
        };

        xdg.configFile."hypr/shader.frag".text = let
            hex2Vec3 = color: "vec3(float((0x${color} >> 16) & 0xFF) / 255.0, float((0x${color} >> 8) & 0xFF) / 255.0, float(0x${color} & 0xFF) / 255.0)";
            hex2Vec4 = color: opacity: "vec4(float((0x${color} >> 16) & 0xFF) / 255.0, float((0x${color} >> 8) & 0xFF) / 255.0, float(0x${color} & 0xFF) / 255.0, ${toString opacity})";
            inherit (config.lib.stylix) colors;
        in ''
#extension GL_EXT_gpu_shader4: enable
#define PIXEL_SIZE_FAC 700.0
#define SPIN_EASE 0.5
#define bkg_color ${hex2Vec4 colors.base00 1.0}
#define bkg_color2 ${hex2Vec4 colors.base01 1.0}
#define resolution vec3(1.0, 1.0, 1.)
#define spin_amount 0.7
#define contrast 1.5
#define tolerance 0.045
#define color_1 ${hex2Vec4 colors.base05 1.0}
#define color_2 ${hex2Vec4 colors.base06 1.0}
#define color_3 ${hex2Vec4 colors.base00 1.0}

precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;
uniform float time;

void main()
{
    vec4 base_color = texture2D(tex, v_texcoord);
    float dist = min(distance(base_color.rgb, bkg_color.rgb), distance(base_color.rgb, bkg_color2.rgb)); 
    if (dist < tolerance){
        //Convert to UV coords (0-1) and floor for pixel effect
        float pixel_size = length(resolution.xy)/PIXEL_SIZE_FAC;
        vec2 uv = (floor(v_texcoord.xy*(1.0/pixel_size))*pixel_size - 0.5*resolution.xy)/length(resolution.xy) - vec2(0.0, 0.0);
        float uv_len = length(uv);

        //Adding in a center swirl, changes with time. Only applies meaningfully if the 'spin amount' is a non-zero number
        float speed = (time*SPIN_EASE*0.1) + 302.2;
        float new_pixel_angle = (atan(uv.y, uv.x)) + speed - SPIN_EASE*20.*(1.*spin_amount*uv_len + (1. - 1.*spin_amount));
        vec2 mid = (resolution.xy/length(resolution.xy))/2.;
        uv = (vec2((uv_len * cos(new_pixel_angle) + mid.x), (uv_len * sin(new_pixel_angle) + mid.y)) - mid);

        //Now add the paint effect to the swirled UV
        uv *= 30.;
        speed = time*(1.);
        vec2 uv2 = vec2(uv.x+uv.y);

        for(int i=0; i < 5; i++) {
            uv2 += uv + cos(length(uv));
            uv  += 0.5*vec2(cos(5.1123314 + 0.353*uv2.y + speed*0.131121),sin(uv2.x - 0.113*speed));
            uv  -= 1.0*cos(uv.x + uv.y) - 1.0*sin(uv.x*0.711 - uv.y);
        }

        //Make the paint amount range from 0 - 2
        float contrast_mod = (0.25*contrast + 0.5*spin_amount + 1.2);
        float paint_res =min(2., max(0.,length(uv)*(0.035)*contrast_mod));
        float c1p = max(0.,1. - contrast_mod*abs(1.-paint_res));
        float c2p = max(0.,1. - contrast_mod*abs(paint_res));
        float c3p = 1. - min(1., c1p + c2p);

        vec4 ret_col = (0.3/contrast)*color_1 + (1. - 0.3/contrast)*(color_1*c1p + color_2*c2p + vec4(c3p*color_3.rgb, c3p*color_1.a)) + 0.3*max(c1p*5. - 4., 0.) + 0.4*max(c2p*5. - 4., 0.);
        gl_FragColor = mix(base_color, ret_col, 0.1 * (1. - dist / tolerance));
    } else {

        gl_FragColor = base_color;
    }
}
        '';
    };

}

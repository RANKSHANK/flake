{
  pkgs,
  user,
  lib,
  ...
}: lib.mkModule "audio" [] {
    
    exec-once = [
        "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1" # Initial mute of default input 
        "pw-loopback" # Listen to inputs
    ];

    keybinds = [
      {
        name = "Media Key Mute";
        combo = ["XF86AudioMute"];
        exec = "set-mute @DEFAULT_AUDIO_SINK@ toggle";
      }
      {
        name = "Media Key Play";
        combo = ["XF86AudioPlay"];
        exec = "playerctl play-pause";
      }
    ];

    users.users.${user} = {
      extraGroups = ["audio"];
    };

    home-manager.users.${user} = {
      services = {
          playerctld.enable = true;
          # easyeffects = {
          #   enable = true;
          # };
      };
    };


    security.rtkit.enable = true;

    services = {
        pulseaudio.enable = false;
        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            # support32Bit = true;
          };
          pulse.enable = true;
          jack.enable = true;
          lowLatency = {
            enable = true;
          };
          extraConfig.pipewire = {
            pipewire-pulse = {
            #     "92-low-latency" = {
            #         context.modules = [
            #         {
            #             name = "libpipewire-module-protocol-pulse";
            #             args = {
            #                 pulse.min.req = "32/48000";
            #                 pulse.default.req = "32/48000";
            #                 pulse.max.req = "32/48000";
            #                 pulse.min.quantum = "32/48000";
            #                 pulse.max.quantum = "32/48000";
            #             };
            #         }
            #         ];
            #         stream.properties = {
            #             node.latency = "32/48000";
            #             resample.quality = 1;
            #         };
            #     };
            };
          };
          wireplumber = {
              enable = true;
              extraConfig = {
                "10-disable-camera" = {
                  "wireplumber.profiles" = {
                    main."monitor.libcamera" = "disabled";
                  };
                };
            };
            extraScripts = {};
          };

        };
    };

    environment = {
      systemPackages = builtins.attrValues {
        inherit (pkgs) playerctl pulsemixer qpwgraph;
      };
    };
}

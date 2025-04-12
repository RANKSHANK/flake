{ lib, config, pkgs, ... }:

lib.mkModule "obs" [ "desktop" "video" ] {
    
    environment.systemPackages = builtins.attrValues {
        obs-studio = let 
            optionals = lib.ternary (lib.isEnabled "wayland" config) [pkgs.obs-studio-plugins.wlrobs] [];
        in pkgs.wrapOBS {
            plugins = lib.flatten [
                (builtins.attrValues {
                    inherit (pkgs.obs-studio-plugins)
                        obs-backgroundremoval
                        obs-pipewire-audio-capture
                        ;
                })
                optionals
            ];
        };
    };

    boot = {
        extraModulePackages = builtins.attrValues {
            inherit (config.boot.kernelPackages)
                v4l2loopback
                ;
        };
        extraModprobeConfig = ''
            options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
        '';
    };
}

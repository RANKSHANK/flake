{
  lib,
  config,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) isEnabled mkModule ternary;
in
  mkModule "obs" ["desktop" "video"] {
    environment.systemPackages = attrValues {
      obs-studio = let
        optionals = ternary (isEnabled "wayland" config) [pkgs.obs-studio-plugins.wlrobs] [];
      in
        pkgs.wrapOBS {
          plugins = lib.flatten [
            (attrValues {
              inherit
                (pkgs.obs-studio-plugins)
                obs-backgroundremoval
                obs-pipewire-audio-capture
                ;
            })
            optionals
          ];
        };
    };

    boot = {
      extraModulePackages = attrValues {
        inherit
          (config.boot.kernelPackages)
          v4l2loopback
          ;
      };
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
    };
  }

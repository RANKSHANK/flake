{
  lib,
  config,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.lists) elem;
  inherit (util) isEnabled mkModule mkIfEnabled ternary;
in
  mkModule "obs" ["desktop" "video"] {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      package = (
        ternary (elem "nvidia" config.boot.kernelModules) (pkgs.obs-studio.override {
          cudaSupport = true;
        }) {}
      );
      plugins = attrValues {
        inherit
          (pkgs.obs-studio-plugins)
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-vkcapture
          ;
        wlrobs = mkIfEnabled "" [ "wayland" ] pkgs.obs-studio-plugins.wlrobs;
      };
    };

    boot = {
      # extraModulePackages = attrValues {
      #   inherit
      #     (config.boot.kernelPackages)
      #     v4l2loopback
      #     ;
      # };
      # extraModprobeConfig = ''
      #   options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      # '';
    };
  }

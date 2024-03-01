{
  pkgs,
  user,
  config,
  lib,
  ...
}: lib.mkModule "audio" [] config {

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
          easyeffects = {
            enable = true;
          };
      };
    };

    sound.enable = false; # alsa

    hardware.pulseaudio.enable = false;

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    environment = {
      systemPackages = builtins.attrValues {
        inherit (pkgs) playerctl pulsemixer qpwgraph;
      };
      etc = {
        # "wireplumber/main.lua.d".source = ./wireplumber;
        # "pipewire/pipewire.d".source = ./pipewire.d;
      };
    };
}

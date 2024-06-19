{
  pkgs,
  user,
  config,
  lib,
  ...
}: let
    # TODO: find a builtin method
    recursiveImport =  dir: map (file: pkgs.writeTextDir "/share/${dir}/${lib.last (lib.splitString "/" (toString file))}" (builtins.readFile file)) (lib.filesystem.listFilesRecursive ./${dir});
in lib.mkModule "audio" [] config {

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
      configPackages = recursiveImport "pipewire";
      wireplumber.configPackages = recursiveImport "wireplumber";

    };

    environment = {
      systemPackages = builtins.attrValues {
        inherit (pkgs) playerctl pulsemixer qpwgraph wineasio;
      };
      # etc = {
      #   "wireplumber/main.lua.d".source = ./wireplumber;
      #   "pipewire/pipewire.d".source = ./pipewire.d;
      # };
    };
}

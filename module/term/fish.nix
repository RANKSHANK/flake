{
  pkgs,
  user,
  config,
  lib,
  ...
}: lib.mkModule "fish" [ "shell" ] config {
    users.defaultUserShell = pkgs.fish;

    programs.fish.enable = true;

    home-manager.users.${user} = {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting
          fish_vi_key_bindings

        '';
        plugins = [
          {
            name = "sponge";
            src = pkgs.fishPlugins.sponge.src;
          }
        ];
      };
    };
}

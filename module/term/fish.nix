{
  pkgs,
  user,
  config,
  lib,
  ...
}: lib.mkModule "fish" [ "shell" ] {
    users.defaultUserShell = pkgs.fish;

    programs.fish.enable = true;

    home-manager.users.${user} = {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting
          fish_vi_key_bindings
          ${lib.ternary (config.modules.neovim.enable) ''set -gx MANPAGER "nvim +Man!"'' ''''}

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

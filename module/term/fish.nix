{
  pkgs,
  user,
  config,
  lib,
  ...
}:
lib.mkModule "fish" ["shell"] {
  users.defaultUserShell = pkgs.fish;

  programs.fish.enable = true;

  home-manager.users.${user} = {
    programs.fish = let
      cfg = config.modules;
    in {
      enable = true;
      interactiveShellInit = lib.concatStringsSep "\n" (lib.flatten [
        ''
          set fish_greeting
          fish_vi_key_bindings
        ''
        (lib.ternary (config.modules.neovim.enable) ''set -gx MANPAGER "nvim +Man!"'' "")
      ]);
      functions = {
        # "nix log" = lib.mkIf cfg.fish.enable {
        #  body = "nix log $argv[1] | bat";
        # };
      };
      binds = {
        "ctrl-backspace" = {
          command = "backward-kill-word";
          mode = "insert";
        };
      };
      plugins = [
        {
          name = "sponge";
          src = pkgs.fishPlugins.sponge.src;
        }
      ];
    };
  };
}

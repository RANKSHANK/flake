{
  config,
  lib,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (lib.strings) concatStringsSep;
  inherit (lib.lists) flatten;
  inherit (util) mkModule ternary;
in
  mkModule "fish" ["shell"] {
    users.defaultUserShell = pkgs.fish;

    programs.fish.enable = true;

    home-manager.users.${user} = {
      programs.fish = {
        enable = true;
        interactiveShellInit = concatStringsSep "\n" (flatten [
          ''
            set fish_greeting
            fish_vi_key_bindings
          ''
          (ternary (config.modules.neovim.enable) ''set -gx MANPAGER "nvim +Man!"'' "")
        ]);
        functions = {
          # "nix log" = mkIf cfg.fish.enable {
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

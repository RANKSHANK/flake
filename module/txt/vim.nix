{
  lib,
  user,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "vim" ["shell"] {
    home-manager.users.${user} = {
      programs.vim = {
        enable = true;
        extraConfig = ''
          set number
          set relativenumber
          set smartindent
        '';
      };
    };
  }

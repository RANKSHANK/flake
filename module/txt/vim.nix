{
  user,
  config,
  lib,
  ...
}: lib.mkModule "vim" [ "shell" ] config {
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

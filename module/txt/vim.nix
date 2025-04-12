{
  user,
  config,
  lib,
  ...
}: lib.mkModule "vim" [ "shell" ] {
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

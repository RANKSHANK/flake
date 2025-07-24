{
  user,
  config,
  lib,
  ...
}:
lib.mkModule "direnv" ["shell"] {
  home-manager.users.${user} = {
    programs.direnv = {
      enable = true;
      config = {
        warn_timeout = "1m";
      };
      nix-direnv = {
        enable = true;
      };
    };
  };
}

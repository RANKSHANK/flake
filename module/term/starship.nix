{
  user,
  config,
  lib,
  ...
}: lib.mkModule "starship" [ "shell" ] config {
    home-manager.users.${user} = {
      programs.starship = {
        enable = true;
        settings = {
          git_metrics.disabled = false;
        };
      };
    };
}

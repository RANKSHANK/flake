{
  config,
  lib,
  user,
  ...
}:
lib.mkModule "alacritty" ["desktop"] {
  # keybinds = [
  #   {
  #     name = "Alacritty";
  #     mods = ["super"];
  #     combo = ["return"];
  #     exec = "alacritty";
  #   }
  # ];
  home-manager.users.${user} = {
    programs.alacritty = {
      enable = true;
    };
  };
}

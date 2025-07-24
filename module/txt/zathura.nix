{
  user,
  config,
  lib,
  ...
}:
lib.mkModule "zathura" ["desktop" "office"] {
  home-manager.users.${user} = {
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        recolor = lib.mkForce true;
      };
    };
  };
}

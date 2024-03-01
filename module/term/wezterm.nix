{ user, lib, config, ... }:

lib.mkModule "wezterm" [ "desktop" ] config {
    home-manager.users.${user} = {
      programs.wezterm = {
        enable = true;
        extraConfig = ''
          return {
              window_close_confirmation = "NeverPrompt",
              --use_fancy_tab_bar = false,
              hide_tab_bar_if_only_one_tab = true,
              enable_scroll_bar = false,
              term = "wezterm",
          };
        '';
      };
    };
}

{
  config,
  lib,
  user,
  ...
}: let
  font = config.stylix.fonts.monospace;
  colors = config.lib.stylix.colors;
in lib.mkModule "mangohud" [ "desktop" "gaming" ] config {
    home-manager.users.${user} = {
      programs.mangohud = {
        enable = true;
        enableSessionWide = true;
        settings = {
          output_folder = "/home/${user}/tmp";
          font_file = "${font.package}/share/fonts/opentype/${builtins.replaceStrings [" "] [""] font.name}-Bold.otf";
          round_corners = 5;
          text_color = colors.base05;
          background_color = colors.base00;
          gpu_color = colors.base0B;
          cpu_color = colors.base0D;
          vram_color = colors.base0C;
          media_player_color = colors.base05;
          engine_color = colors.base0E;
          wine_color = colors.base0E;
          frametime_color = colors.base0B;
          battery_color = colors.base04;
          io_color = colors.base0A;
        };
      };
      xdg.configFile."MangoHud/MangoHud.conf".text = ''
        cpu_temp
        gpu_temp
        gpu_name
        vram
        ram
        swap
        vulkan_driver
        no_display
      '';
    };
}

{
  config,
  user,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "mangohud" ["desktop" "gaming"] {
    home-manager.users.${user} = {
      programs.mangohud = {
        enable = true;
        enableSessionWide = true;
        settings = {
          output_folder = "/home/${user}/tmp";
          toggle_hud = "Shift_L+F5";
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

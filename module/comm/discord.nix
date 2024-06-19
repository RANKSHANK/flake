{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (pkgs) discord;
  discordOverlay = self: super: {
    discord = super.discord.override {
      withOpenASAR = true;
    };
  };
in lib.mkModule "discord" [ "communication" ] config {
    nixpkgs.overlays = [discordOverlay];

    environment.systemPackages = [
      # discord
      pkgs.vesktop
      # (lib.mkIf (builtins.all (req: lib.isEnabled req config) ["wayland" "hardware.nvidia"]) (
      #   lib.patchDesktopEntry pkgs discord "discord"
      #   ["^Exec=Discord"]
      #   ["Exec=nvidia-offload Discord --enable-features=UseOzonePlatform --ozone-platform=wayland"]
      # ))
    ];

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "discord"
      ];
}

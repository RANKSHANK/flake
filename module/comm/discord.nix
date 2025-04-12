{
  pkgs,
  lib,
  config,
  user,
  inputs,
  ...
}: let
  # inherit (pkgs) discord;
  # discordOverlay = self: super: {
  #   discord = super.discord.override {
  #     withOpenASAR = true;
  #   };
  # };
in lib.mkModule "discord" [ "desktop" "communication" ] {

    # imports = [
    #     inputs.arrpc.homeManagerModules.default
    # ];
   
    # home-manager.users.${user} = {
    #     services.arrpc.enable = lib.mkForce true;
    # };

    # nixpkgs.overlays = [discordOverlay];

    environment.systemPackages = [
      # discord
      pkgs.vesktop
      # (lib.mkIf (builtins.all (req: lib.isEnabled req config) ["wayland" "hardware.nvidia"]) (
      #   lib.patchDesktopEntry pkgs discord "discord"
      #   ["^Exec=Discord"]
      #   ["Exec=nvidia-offload Discord --enable-features=UseOzonePlatform --ozone-platform=wayland"]
      # ))
      # pkgs.arrpc
    ];


    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "discord"
      ];

    # systemd.user.services.arRPC = {
    #     description = "Discord Rich Presence Server";
    #     partOf = ["graphical-session.target"];
    #     after = ["graphical-session.target"];
    #     wantedBy = ["graphical-session.target"];
    #     startLimitIntervalSec = 500;
    #     startLimitBurst = 5;
    #
    #     serviceConfig = {
    #         ExecStart = "${lib.getExe pkgs.arrpc}";
    #         Restart = "always";
    #         RestartSec ="5s";
    #     };
    # };
}

{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  steamOverlay = self: super: {
    steam = super.steam.override {
      extraPkgs = pkgs:
        builtins.attrValues {
          inherit (pkgs) keyutils libkrb5 libpng libpulseaudio libvorbis;
          inherit (pkgs.stdenv.cc.cc) lib;
          inherit (pkgs.xorg) libXcursor libXi libXinerama libXScrnSaver;
        };
    };
  };
in lib.mkModule "steam" [ "desktop" "gaming" ] config {

  imports = [
    inputs.nix-gaming.nixosModules.steamCompat
  ];

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) steamcmd steam-run;
    };

    nixpkgs.overlays = [
      steamOverlay
    ];

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = false;
        gamescopeSession.enable = true;
        extraCompatPackages = builtins.attrValues {
          inherit (inputs.nix-gaming.packages.${pkgs.system}) proton-ge;
        };
      };
      gamemode.enable = true;
    };

    hardware.steam-hardware.enable = true;

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-runtime"
      ];
}

{
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
          inherit (pkgs) proton-ge-bin;
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

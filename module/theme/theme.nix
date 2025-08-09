{
  pkgs,
  lib,
  config,
  user,
  ...
}: let
  inherit (lib.modules) mkForce mkIf;
  font = {
    package = pkgs.nerd-fonts.fira-code;
    name = "FiraCode Nerd Font Mono";
    # package = pkgs.nerd-fonts.jetbrains-mono;
    # name = "JetBrains Nerd Font Mono";
    # package = pkgs.jetbrains-mono;
    # name = "Comic Nerd Font Mono";
    # package = pkgs.comic-mono;
    # package = pkgs.monaspace;
    # name = "Monaspace Nerd Font Krypton Mono";
  };
in {
  stylix = {
    enable = true;
    polarity = "dark";
    image = mkForce null;

    base16Scheme = pkgs.callPackage ./scheme.nix {};
    opacity = {
      desktop = 1.0;
      applications = 1.0;
      popups = 0.5;
      terminal = 0.9;
    };
    fonts = {
      sizes = {
        desktop = 16;
        applications = 16;
        popups = 16;
        terminal = 20;
      };
      monospace = font;
      serif = font;
      sansSerif = font;
      #emoji = font;
    };
    cursor = {
      package = pkgs.phinger-cursors;
      # package = pkgs.material-cursors;
      size = 16;
      name = "phinger-cursors-dark";
      # name = "material-dark";
    };
  };

  home-manager.users = mkIf (user != null) {
    ${user}.gtk.iconTheme = {
      package = pkgs.beauty-line-icon-theme;
      name = "BeautyLine";
    };
  };
}

{
  pkgs,
  lib,
  user,
  ...
}: let
  inherit (lib.modules) mkForce mkIf;
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
    fonts = import ./font.nix { inherit pkgs; };
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

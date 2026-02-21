{
  pkgs,
  lib,
  user,
  util,
  ...
}: let
  inherit (lib.modules) mkForce mkIf;
  inherit (util) isEnabled mkIfEnabled ternary;
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
    } // (ternary (isEnabled "" ["desktop"]) {

    fonts = import ./font.nix { inherit pkgs; };
    cursor = {
      package = pkgs.phinger-cursors;
      # package = pkgs.material-cursors;
      size = 16;
      name = "phinger-cursors-dark";
      # name = "material-dark";
    };
  } {});

  home-manager.users = mkIf (user != null) {
    ${user}.gtk.iconTheme = mkIfEnabled "" ["desktop"]{
      package = pkgs.beauty-line-icon-theme;
      name = "BeautyLine";
    };
  };
}

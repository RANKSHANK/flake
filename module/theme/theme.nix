{pkgs, lib, config, user, ...}: lib.mkModule "theme" [ "system" ] config {

  stylix = let
    font = {
       # package = pkgs.nerd-fonts.fira-code;
       # name = "FiraCode";
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrains Mono";
      # package = pkgs.jetbrains-mono;
      # name = "Comic Mono";
      # package = pkgs.comic-mono;
      # package = pkgs.monaspace;
      # name = "Monaspace Krypton";
    };
  in {
    enable = true;
    polarity = "dark";
    image = 
    # pkgs.fetchurl {
    #   url = "https://images.alphacoders.com/695/69561.jpg";
    #   sha256 = "sha256-RKhIar3wMwo/5rWG5AdQbnOP4HX+C138Q5YeNY/acgY=";
    # };
    config.lib.stylix.pixel "base00";

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
    opacity = {
      desktop = 1.0;
      applications = 1.0;
      popups = 0.5;
      terminal = 0.9;
    };
    fonts = {
      sizes = {
        desktop = 16;
        applications = 10;
        popups = 16;
        terminal = 16;
      };
      monospace = font;
      serif = font;
      sansSerif = font;
      # {
      #   name = "ComicRelief";
      #   package = pkgs.comic-relief;
      #   # name = "Cantarell";
      #   # package = pkgs.cantarell-fonts;
      # };
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
  home-manager.users.${user} = {
    gtk.iconTheme = { 
      package = pkgs.beauty-line-icon-theme;
      # size = 16;
      name = "BeautyLine";
    };
  };
}

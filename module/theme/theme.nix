{pkgs, lib, config, inputs, ...}: lib.mkModule "theme" [ "system" ] config {
  fonts.packages = [
    (pkgs.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "FiraCode"
        "Monaspace"
      ];
    })
  ];

  stylix = let
    font = {
       # package = pkgs.fira-code;
       # name = "FiraCode";
      package = pkgs.nerdfonts;
      name = "JetBrains Mono";
      # package = pkgs.monaspace;
      # name = "Monaspace Krypton";
    };
  in {
    polarity = "dark";
    image = pkgs.fetchurl {
      url = "https://images.alphacoders.com/695/69561.jpg";
      sha256 = "sha256-RKhIar3wMwo/5rWG5AdQbnOP4HX+C138Q5YeNY/acgY=";
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    opacity = {
      desktop = 0.9;
      applications = 0.95;
      popups = 0.5;
      terminal = 0.9;
    };
    fonts = {
      sizes = {
        desktop = 16;
        applications = 16;
        popups = 16;
        terminal = 16;
      };
      monospace = font;
      serif = font;
      sansSerif = font;
      #emoji = font;
    };
    cursor = {
      package = pkgs.beauty-line-icon-theme;
      size = 16;
      name = "BeautyLine";
    };
  };
}

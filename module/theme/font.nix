{
  pkgs,
  ...
}:
  let
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
  in
  {
    sizes = {
      desktop = 16;
      applications = 16;
      popups = 16;
      terminal = 20;
    };
    monospace = font;
    serif = font;
    sansSerif = font;
    emoji = font;
  }

{
  config,
  lib,
  ...
}: lib.mkModule "flatpak" [ "repo" "desktop" ] config {
    xdg.portal.enable = true;
    services.flatpak = {
      enable = true;
      # packages = [
      #   "flathub:app/net.lutris.Lutris//master"
      # ];
      # remotes = {
      #   "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      #   "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      # };
    };
}

{
  config,
  lib,
  ...
}: lib.mkModule "flatpak" [ "repo" "desktop" ] config {
    xdg.portal.enable = true;
    services.flatpak = {
      enableModule = false;
      enable = false;
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      };
      packages = [
        # "flathub-beta:app/org.freecadweb.FreeCAD/x86_64/beta"
      ];
    };
}

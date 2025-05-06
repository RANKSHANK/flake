{
  inputs,
  config,
  lib,
  ...
}: lib.mkModule "flatpak" [ "repo" "desktop" ] {
    imports = [
        inputs.flatpak.nixosModule
    ];
    xdg.portal.enable = true;
    services.flatpak = {
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

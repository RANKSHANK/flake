{
  inputs,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "flatpak" ["repo"] {
    imports = [
      inputs.flatpak.nixosModules.default
    ];
    xdg.portal.enable = true;
    services.flatpak = {
      enable = true;
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      };
      packages = [
        # "flathub-beta:app/org.freecadweb.FreeCAD/x86_64/beta"
      ];
    };
  }

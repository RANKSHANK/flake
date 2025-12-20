{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mapAttrsToList;
  inherit (builtins) throw;
in
  mapAttrsToList (
    name: attrs:
      if (attrs.package.outPath == attrs.path)
      then attrs.disabledModule
      else
        (throw ''
          ${name} marked broken due to ${attrs.reason}.
          ${name} hash has changed, verify package is still broken and update path.

          Specified store path:
            ${attrs.path}

          Package store path:
            ${attrs.package.outPath}


        '')
  )
  {
    # "spyder" = {
    #   package = pkgs.spyder;
    #   reason = "Missing setuptools.build_meta";
    #   disabledModule = "spyder";
    #   path = "/nix/store/r24rxgm82zn9kipm7z1hd6x5nnvp85a2-python3.13-spyder-6.1.0a2";
    # };
    # "satisfactory-mod-manager" = {
    #   package = pkgs.satisfactorymodmanager;
    #   reason = "qt5-webengine CVE";
    #   disabledModule = "satisfactory-mod-manager";
    #   path = "/nix/store/7k7b0f3sg1nsayb6sgx08wzlarx589cv-satisfactorymodmanager-3.0.3";
    # };
  }

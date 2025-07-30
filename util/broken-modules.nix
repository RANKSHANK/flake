{
  pkgs,
  lib,
  ...
}: let
  packages = {
    "orca-slicer" = {
      package = pkgs.orca-slicer;
      reason = "libsoup EOL/CVEs";
      disabledModule = "orca";
      hash = "sha256-MEa57jFBJkqwoAkqI7wXOn1X1zxgLQt3SNeanfD88kU=";
    };
    "spyder" = {
      package = pkgs.spyder;
      reason = "Missing setuptools.build_meta";
      disabledModule = "spyder";
      hash = "sha256-KbGfG9T3XkYXntIQx325mYb0Bh8c0idb+25awFlWD9s=";
    };
  };
  inherit (lib) mapAttrsToList;
  inherit (builtins) throw;
in
  mapAttrsToList (
    name: attrs:
      if (attrs.package.src.outputHash == attrs.hash)
      then (attrs.disabledModule)
      else
        (throw ''
          ${name} marked broken due to ${attrs.reason}.
          ${name} hash has changed, verify package is still broken and update hash.

          Specified hash:
            ${attrs.hash}

          Package hash:
            ${attrs.package.src.outputHash}
        '')
  )
  packages

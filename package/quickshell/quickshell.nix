{
  inputs,
  lib,
  pkgs,
  theme ? pkgs.callPackage ./theme.nix { inherit inputs; },
  sounds ? pkgs.callPackage ./sounds.nix { inherit inputs; },
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues mapAttrs;
  inherit (inputs.mqsw.lib) wrap;
  inherit (lib.fileset) toSource unions;
  fromNpins = mapAttrs (pname: src: pkgs.stdenv.mkDerivation {
    inherit pname src;
    version = "0.0";
    installPhase = ''
      mkdir -p $out
      cp -r ${src}* $out/
    '';

  }) (util.fromNpins ./sources.json);
in wrap pkgs {
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell.withModules [
      pkgs.kdePackages.qtmultimedia
    ];
  sources = {
    packaged = attrValues {
      theme = theme // { linkPath = "vars"; };
      sounds = sounds // { linkPath = "vars"; };
    };
    local = {
      pure = toSource {
        root = ./shell;
        fileset = unions [./shell];
      };
      impure = "/home/rankshank/projects/flake/package/quickshell/shell";
    };
  };
}

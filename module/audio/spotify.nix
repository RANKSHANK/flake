{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
lib.mkModule "spotify" ["audio" "desktop"] {
  programs.spicetify = {
    enable = true;
    enabledExtensions = builtins.attrValues {
      inherit
        (inputs.spicetify.legacyPackages.${pkgs.system}.extensions)
        adblock
        hidePodcasts
        keyboardShortcut
        shuffle
        trashbin
        ;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
    ];
}

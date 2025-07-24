{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkModule "lutris" ["gaming" "desktop"] {
  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraPkgs = pkgs: [
        # (wineWowPackages.waylandFull.override {
        #   wineRelease = "staging";
        #   mingwSupport = true;
        # })
        winetricks
      ];
    })
  ];
}

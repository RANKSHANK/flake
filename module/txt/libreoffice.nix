{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "libreoffice" [ "desktop" "office" ] config {
    environment = {
      systemPackages = builtins.attrValues {
        inherit (pkgs) hunspell libreoffice-qt;
        inherit (pkgs.hunspellDicts) en_US en_AU;
      };
    };
}

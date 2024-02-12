{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "xournal" [ "desktop" "office" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) xournalpp;
    };
}

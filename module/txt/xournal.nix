{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "xournal" [ "desktop" "office" ] {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) xournalpp;
    };
}

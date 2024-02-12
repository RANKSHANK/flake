{
  config,
  lib,
  pkgs,
  ...
}: lib.mkModule "git" [ "shell" ] config {
    programs = {
      git.enable = true;
    };
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) gh;
    };
}

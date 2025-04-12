{
  config,
  lib,
  pkgs,
  ...
}: lib.mkModule "git" [ "shell" ] {
    programs = {
      git.enable = true;
    };
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) gh;
    };
}

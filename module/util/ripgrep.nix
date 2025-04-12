{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "ripgrep" [ "shell" ] {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) ripgrep;
    };
}

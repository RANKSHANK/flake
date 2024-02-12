{
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "ripgrep" [ "shell" ] config {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) ripgrep;
    };
}

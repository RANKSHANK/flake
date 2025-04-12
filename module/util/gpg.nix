{
  config,
  lib,
  pkgs,
  ...
}: lib.mkModule "gpg" [ "shell" ] {
    programs = {
      gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-curses;
        enableSSHSupport = true;
      };
    };
    services.pcscd.enable = true;
}

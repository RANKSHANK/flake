{
  pkgs,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "gpg" ["shell"] {
    programs = {
      gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-curses;
        enableSSHSupport = true;
      };
    };
    services.pcscd.enable = true;
  }

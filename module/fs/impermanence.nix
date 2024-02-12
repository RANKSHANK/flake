{
  config,
  lib,
  ...
}: lib.mkModule "impermanence" [] config {
    environment = {
      persistence = {
        "/persist" = {
          hideMounts = true;
          directories = lib.flatten [
            "/etc/NetworkManager/system-connections"
            "/etc/ssh"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/var/log"
          ];
          files = lib.flatten [
            "/etc/machine-id"
          ];
        };
      };
    };

    programs.fuse.userAllowOther = true;

    fileSystems."/persist".neededForBoot = true;
}

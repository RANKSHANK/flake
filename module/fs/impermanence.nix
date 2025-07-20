{
  inputs,
  config,
  lib,
  ...
}: lib.mkModule "impermanence" [] {

    imports = [
        inputs.impermanence.nixosModules.impermanence
    ];

    environment = {
      persistence = {
        "/persist" = {
          hideMounts = true;
          directories = lib.flatten [
            "/root"
            "/etc/NetworkManager/system-connections"
            "/etc/ssh"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/var/log"
            (lib.mkIf config.modules.tailscale.enable "/var/lib/tailscale")
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

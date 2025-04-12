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
            "/etc/NetworkManager/system-connections"
            "/etc/ssh"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            (lib.mkIf config.modules.changedetection-io.enabled "/var/lib/changedetection-io")
            (lib.mkIf config.modules.searxng.enabled "/var/lib/redis-searx")
            (lib.mkIf config.modules.vikunja.enabled {
                directory = "/var/lib/vikunja";
                user = "vikunja";
                group = "vikunja";
            })
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

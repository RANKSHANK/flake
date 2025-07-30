{
  inputs,
  config,
  lib,
  util,
  ...
}: let
  inherit (lib.lists) flatten;
  inherit (lib.modules) mkIf;
  inherit (util) mkModule;
in
  mkModule "impermanence" [] {
    imports = [
      inputs.impermanence.nixosModules.impermanence
    ];

    environment = {
      persistence = {
        "/persist" = {
          hideMounts = true;
          directories = flatten [
            "/root"
            "/etc/NetworkManager/system-connections"
            "/etc/ssh"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/var/log"
            (mkIf config.modules.tailscale.enable "/var/lib/tailscale")
          ];
          files = flatten [
            "/etc/machine-id"
          ];
        };
      };
    };

    programs.fuse.userAllowOther = true;

    fileSystems."/persist".neededForBoot = true;
  }

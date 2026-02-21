{ inputs, user, pkgs, lib, ... }:
let
  inherit (lib.attrsets) attrValues;
in {

  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
    };

    deviceTree = {
      enable = true;
      # filter = "*rpi-4-*.dtb";
      overlays = [
        {
          name = "spi";
          dtboFile = ./device-tree/spi0-0cs.dtbo;

        }
      ];
    };
  };

  console.enable = true;

  nixpkgs.overlays = [
    (_: super: { libcec = super.libcec.override {
      withLibraspberrypi = true;
    };})
  ];

  environment.systemPackages = attrValues {
    inherit (pkgs)
      libraspberrypi
      raspberrypi-eeprom
      libcec
    ;
  };

  systemd = {
    sockets.cec-client = {
      after = [ "dev-vchiq.device" ];
      bindsTo = [ "dev-vchiq.device" ];
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenFIFO = "/run/cec.fifo";
        SocketGroup = "video";
        SocketMode = "0660";
      };
    };
    services."cec-client" = {
      after = [ "dev-vchiq.device" ];
      bindsTo = [ "dev-vchiq.device" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''${pkgs.libcec}/bin/cec-client - d 1'';
        ExecStop = ''/bin/sh -c "echo q > /run/cec.fifo"'';
        StandardInput = "socket";
        StandardOutput = "journal";
        Restart = "no";
      };
    };
  };

  users = {
    groups.spi = {};
    users.${user} = {
      extraGroups = [
        "gpio"
        "spi"
      ];
    };
  };
}

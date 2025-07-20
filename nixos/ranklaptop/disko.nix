{ lib, ...}: let
  rootDisk = "nvme0n1";
  homeDisk = "sda";
  swapSizeG = 32;
  mountOptions = ["noatime" "compress=zstd" "nodiratime" "discard"];
  extraArgs = ["-f"];
in {
  boot.initrd = {
    postDeviceCommands = lib.mkBefore (import ../../script/btrfs-subvol-cylcler.nix "luks-root");
    luks.devices."luks-root" = {
        # device = "/dev/disk/by-partlabel/disk-${rootDisk}-luks";
        allowDiscards = true;
        preLVM = true;
    };

  };

  disko.devices = {

    disk = {
      ${rootDisk} = {
        type = "disk";
        device = "/dev/${rootDisk}";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "512M";
              type = "EF02";
            };
            esp = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              size = "${toString swapSizeG}G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "luks-root";
                content = {
                  type = "btrfs";
                  inherit extraArgs;
                  subvolumes = let
                    mtOpts = name: extra: lib.flatten [ 
                        "subvol=${name}"
                        "noatime"
                        "compress=zstd"
                        extra
                    ];
                  in {
                    "/root" = {
                        mountpoint = "/";
                        mountOptions = mtOpts "root" [];
                    };
                    "/snapshots" = {
                        mountOptions = [ "subvol=snapshots" "nodatacow" "noatime" ]; 
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = mtOpts "nix" [];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = mtOpts "persist" [];
                    };
                  };
                };
              };
            };
          };
        };
     };
      ${homeDisk} = {
          type = "disk";
          device = "/dev/${homeDisk}";
          content = {
              type = "gpt";
              partitions = {
                  luks = {
                      size = "100%";
                      content = {
                          type = "luks";
                          name = "luks-home";
                          content = {
                              type = "btrfs";
                              inherit extraArgs;
                              subvolumes = {
                                  "/home" = {
                                      mountpoint = "/home";
                                      inherit mountOptions;
                                  };
                              };
                          };
                      };
                  };
              };
          };
      };
    };
  };
}

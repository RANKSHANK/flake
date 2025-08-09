{lib, ...}: let
  inherit (lib.modules) mkBefore;
  inherit (lib.lists) flatten;
  rootDisk = "wwn-0x5002538870016672";
  nixDisk = "wwn-0x5002538e406c3bda";
  userDisk = "wwn-0x5000c5007924f326";
  swapSizeG = 128;
  mtOpts = name: extra:
    flatten [
      "subvol=${name}"
      "noatime"
      "compress=zstd"
      extra
    ];
in {
  boot.initrd = {
    postDeviceCommands = mkBefore (import ../../script/btrfs-subvol-cylcler.nix "luks-root");
    luks = {
      devices."luks-root" = {
        allowDiscards = true;
        preLVM = true;
      };
      reusePassphrases = true;
    };
  };

  disko.devices = {
    disk = {
      root = {
        type = "disk";
        device = "/dev/disk/by-id/${rootDisk}";
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
                  extraArgs = ["-L" "root" "-f"];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = mtOpts "root" [];
                    };
                    "/snapshots" = {
                      mountOptions = ["subvol=snapshots" "nodatacow" "noatime"];
                    };
                  };
                };
              };
            };
          };
        };
      };
      nix = {
        type = "disk";
        device = "/dev/disk/by-id/${nixDisk}";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "luks-nix";
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "nix" "-f"];
                  subvolumes = {
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = mtOpts "nix" [];
                    };
                  };
                };
              };
            };
          };
        };
      };
      user = {
        type = "disk";
        device = "/dev/disk/by-id/${userDisk}";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "luks-user";
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "user" "-f"];
                  subvolumes = {
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = mtOpts "home" [];
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
    };
  };
}

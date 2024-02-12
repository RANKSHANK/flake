{...}: let
  rootDisk = "sda";
  homeDisk = "sdb";
  swapSizeG = 32;
  mountOptions = ["noatime" "compress=zstd" "nodiratime" "discard"];
  extraArgs = ["-f"];
in {
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        #"size=${builtins.toString tmpfsSizeG}G"
        "defaults"
        "mode=755"
      ];
    };
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
                name = "crypted_${rootDisk}";
                content = {
                  type = "btrfs";
                  inherit extraArgs;
                  subvolumes = {
                    "/nix" = {
                      mountpoint = "/nix";
                      inherit mountOptions;
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      inherit mountOptions;
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
                name = "crypted_${homeDisk}";
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

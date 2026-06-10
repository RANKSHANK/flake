{lib, pkgs, ...}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.modules) mkBefore;
  inherit (lib.lists) flatten;
  rootDisk = "nvme0n1";
  homeDisk = "sda";
  swapSizeG = 32;
  mountOptions = ["noatime" "compress=zstd" "nodiratime" "discard"];
  extraArgs = ["-f"];
in {
  boot.initrd.systemd = {
    enable = true;
    services.btrfs-subvol-cycler = {
      description = "Subvol cycling for impermanence";
      wantedBy = [ "initrd.target" ];
      requires = [ "systemd-cryptsetup@luks\\x2droot.service" ];
      after = [
        "systemd-cryptsetup@luks\\x2droot.service"
        "systemd-hibernate-resume.service"
      ];
      before = [
        "sysroot.mount"
        "initrd-root-fs.target"
      ];
      unitConfig.DefaultDependenceies = false;
      serviceConfig = {
        Type = "oneshot";
      };
      path = attrValues {
        inherit (pkgs)
          btrfs-progs
          coreutils
          findutils
          gawk
          gnugrep
          gnused
          util-linux
        ;
      };
      script = import ../../script/btrfs-subvol-cylcler.nix "luks-root";
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
                    mtOpts = name: extra:
                      flatten [
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
                      mountOptions = ["subvol=snapshots" "nodatacow" "noatime"];
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
                settings = {
                  allowDiscards = true;
                  crypttabExtraOpts = [ "password-cache=yes" ];
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
                settings = {
                  allowDiscards = true;
                  crypttabExtraOpts = [ "password-cache=yes" ];
                };
              };
            };
          };
        };
      };
    };
  };
}

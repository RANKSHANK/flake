{lib, pkgs, ...}: let
  inherit (lib.attrsets) attrValues;
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
                settings = {
                  allowDiscards = true;
                  crypttabExtraOpts = [ "password-cache=yes" ];
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
                  settings = {
                    crypttabExtraOpts = [ "password-cache=yes" ];
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

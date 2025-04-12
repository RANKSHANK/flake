{...}: let
  rootDisk = "/dev/disk/by-id/ata-UDSS_UD3CS1HT301-256G_TUSJA24BNX01378";
  storageDisk = "/dev/disk/by-id/usb-Samsung_PSSD_T7_Shield_S6SGNS0X600702J-0:0";
  swapSizeG = 16;
  bootSizeM = 512;
  espSizeM = 512; 
  homeSizeG = 100;
  mountOptions = ["noatime" "compress=zstd" "nodiratime" "discard"];
in {
  disko.devices = {
    disk = {
      ${rootDisk} = {
        type = "disk";
        device = rootDisk;
        
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "${toString bootSizeM}M";
	      priority = 2;
              type = "EF02";
            };
            esp = {
              size = "${toString espSizeM}M";
	      priority = 2;
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              size = "${toString swapSizeG}G";
	      priority = 3;
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            root = {
              size = "100%";
	      priority = 4;
              content = {
                type = "btrfs";
                extraArgs = [];
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
                    inherit mountOptions;
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    inherit mountOptions;
                  };
                };
              };
            };
            home = {
              size = "${toString homeSizeG}G";
	      priority = 2;
              content = {
                type = "btrfs";
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
      storage = {
        type = "disk";
        device = storageDisk;
        content = {
          type = "gpt";
          partitions = {
            storage = {
	      priority = 2;
              size = "100%";
              content = {
                type = "btrfs";
		mountOptions = builtins.concatLists [mountOptions  [ "nofail" ]];
	        mountpoint = "/storage";
	      };
	    };
	  };
	};
      };
    };
  };
}

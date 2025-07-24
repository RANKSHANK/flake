targetDrive: let
  # stolen from: saylesss88@github.io
  logName = "subvol-cylce.log";
in ''
  mkdir -p /mnt
  mount -o subvol=/ /dev/mapper/${targetDrive} /mnt

  btrfs subvolume list -o /mnt/root | cut -f9 -d' ' | while read subvolume; do
    btrfs subvolume delete "/mnt/$subvolume"
  done

  btrfs subvolume delete /mnt/root

  btrfs subvolume snapshot /mnt/snapshots/root-blank /mnt/root

  umount /mnt
''

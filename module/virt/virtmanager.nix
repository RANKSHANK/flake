{
  pkgs,
  user,
  config,
  lib,
  ...
}: lib.mkModule "virtmanager" [ "virtualization" ] {
    virtualisation.libvirtd.enable = true;

    programs.dconf.enable = true;

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) virt-manager qemu_kvm;
    };

    users.users.${user}.extraGroups = ["libvirtd"];
}

{
  pkgs,
  user,
  config,
  lib,
  ...
}:
lib.mkModule "virtmanager" ["virtualization"] {
  security.wrappers.spice-client-glib-usb-acl-helper.source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [pkgs.virtiofsd];
    };
  };

  programs = {
    dconf.enable = true;
    virt-manager.enable = true;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) virt-manager qemu_kvm spice-gtk;
  };

  users.users.${user}.extraGroups = ["libvirtd"];

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };
}

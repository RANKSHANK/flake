{lib, ...}: {
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}

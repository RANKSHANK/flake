{
util,
...
}: let
inherit (util) genUdevRules;

in {

  services.udev.packages = [
    (genUdevRules "can" 10 ''
      SUBSYSTEM=="net", ACTION=="change|add", KERNEL=="can*", ATTR{tx_queue_len}="128"
    '')
    (genUdevRules "spi" 99 ''
      SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"
    '')
    (genUdevRules "vchiq" 99 ''
       KERNEL=="vchiq", GROUP="video", MODE="0660", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/vchiq"
    '')
  ];

  systemd.network = {
    enable = true;
    wait-online.enable = false;
  };

  environment.etc = {
    "systemd/network/25-can.network" = {
    text = ''
      [Match]
      Name=can*

      [CAN]
      BitRate=1000000

      [CANOptions]
      RestartBehavior=auto

      [Link]
      RequiredForOnline=no
    '';

    };
  };
}

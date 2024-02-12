{
  lib,
  config,
  inputs,
  ...
}: lib.mkModule "sops" [] config {
    sops = {
      age.keyFile = "/tmp/flup.txt";
      defaultSopsFile = "${inputs.self}/secrets.yaml";
    };
}

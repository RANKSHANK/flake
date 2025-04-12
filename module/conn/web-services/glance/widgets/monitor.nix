{ config, lib, ... }:

{
    type = "monitor";
    title = "services";
    sites = [
        (lib.mkIf config.services.changedetection-io.enable {
             title = "Change Detection";
             url = "http://${config.services.changedetection-io.listenAddress}:${toString config.services.changedetection-io.port}";
         })
        (lib.mkIf config.services.vikunja.enable {
             title = "Vikunja";
             url = "http://${config.services.vikunja.frontendHostname}:${toString config.services.vikunja.port}";
         })
    ];

}

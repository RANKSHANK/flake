{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  type = "monitor";
  title = "services";
  sites = let
    mkURL = urlHead: "https://${urlHead}.${config.baseURL}";
  in [
    (mkIf config.services.changedetection-io.enable {
      title = "Change Detection";
      url = mkURL "changedetection-io";
    })
    (mkIf config.services.vikunja.enable {
      title = "Vikunja";
      url = mkURL "vikunja";
    })
    (mkIf config.services.searx.enable {
      title = "SearXNG";
      url = mkURL "searx";
    })
    (mkIf config.services.gotify.enable {
      title = "Gotify";
      url = mkURL "gotify";
    })
  ];
}

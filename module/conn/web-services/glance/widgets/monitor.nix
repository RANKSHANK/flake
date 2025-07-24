{
  config,
  lib,
  ...
}: {
  type = "monitor";
  title = "services";
  sites = let
    mkURL = urlHead: "https://${urlHead}.${config.baseURL}";
  in [
    (lib.mkIf config.services.changedetection-io.enable {
      title = "Change Detection";
      url = mkURL "changedetection-io";
    })
    (lib.mkIf config.services.vikunja.enable {
      title = "Vikunja";
      url = mkURL "vikunja";
    })
    (lib.mkIf config.services.searx.enable {
      title = "SearXNG";
      url = mkURL "searx";
    })
    (lib.mkIf config.services.gotify.enable {
      title = "Gotify";
      url = mkURL "gotify";
    })
  ];
}

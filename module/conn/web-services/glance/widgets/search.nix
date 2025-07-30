{
  config,
  lib,
  ...
}: let
  inherit (lib.strings) replaceStrings;
  inherit (lib.lists) head;
in {
  type = "search";
  search-engine = replaceStrings ["{}"] ["{QUERY}"] (head config.browsers.searchEngines).url;
  bangs =
    map (eng: {
      title = eng.name;
      shortcut = "!${eng.shortcut}";
      url = replaceStrings ["{}"] ["{QUERY}"] eng.url;
    })
    config.browsers.searchEngines;
}

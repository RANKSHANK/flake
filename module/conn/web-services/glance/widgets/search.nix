{ config, lib, ... }:

{
    type = "search";
    search-engine = (builtins.replaceStrings [ "{}" ] [ "{QUERY}" ] (lib.head config.browsers.searchEngines).url);
    bangs = map (eng: {
        title = eng.name;
        shortcut = "!${eng.shortcut}";
        url = builtins.replaceStrings [ "{}" ] [ "{QUERY}" ] eng.url;
    }) config.browsers.searchEngines;
}

{
  lib,
  config,
  ...
}: lib.mkModule "bookmarks" [ "desktop" "connectivity" ] config {
  browsers = lib.mkIfEnabled "desktop" config {
    homePage = "https://search.brave.com";
    searchEngines = [
      {
        name = "Brave";
        shortcut = "br";
        url = "https://search.brave.com/search?q={}";
        icon = "https://brave.com/static-assets/images/brave-logo-sans-text.svg";
      }
      {
        name = "IsThereAnyDeal";
        shortcut = "ad";
        url = "https://isthereanydeal.com/search/?q={}";
      }
      {
        name = "OzBargain Deals";
        shortcut = "ob";
        url = "https://www.ozbargain.com.au/search/node/{}%20type%3Aozbdeal%20option%3Anocomment%20sort%3Acreated";
      }
      {
        name = "Arch Wiki";
        shortcut = "aw";
        url = "https:/wiki.archlinux.org/index.php?search={}&title=Special%3ASearch&wprov=arcw1";
      }
      {
        name = "Reddit";
        shortcut = "rd";
        url = "https://old.reddit.com/search?q={}";
      }
      {
        name = "Github";
        shortcut = "gh";
        url = "https://github.com/search?q={}";
      }
      {
        name = "Home-Manager Options";
        shortcut = "ho";
        url = "https://mipmip.github.io/home-manager-option-search/?query={}";
      }
      {
        name = "Nix Discourse";
        shortcut = "nd";
        url = "https://discourse.nixos.org/search?1={}";
      }
      {
        name = "Nix Wiki";
        shortcut = "nw";
        url = "https://nixos.wiki/index.php?search={}";
      }
      {
        name = "Nix Options";
        shortcut = "no";
        url = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      }
      {
        name = "Nix Packages";
        shortcut = "np";
        url = "https://search.nixos.org/packages?channel=unstable&query={}";
      }
      {
        name = "Youtube";
        shortcut = "yt";
        url = "https://youtube.com/results?search_query={}";
      }
    ];
  };
}

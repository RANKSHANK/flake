{ lib, config, ... }:

lib.mkModule "searxng" [ "connectivity" ] config {


    services.searx = {
        enable = true;
        redisCreateLocally  = true;
        # runInUwsgi = true;
        # uwsgiConfig = {
        #     socket = "/run/searx/searx.sock";
        #     http = ":8888";
        #     cmhod-socket = "660";
        # };
        settings = {

            server = {
                # base_url = "";
                bind_address = "localhost";
                port = 8888;
                secret_key = "no u";
            };

            ui = {
            };

            search = {
                safe_search = 0;
                autocomplete_min = 2;
                autocomplete = "brave";
            };

            general = {
                donation_url = false;
                contact_url = false;
                privacypolicy_url = false;
                enable_metrics = false;
            };

            outgoing = {
                enable_http2 = true;
                # using_tor_proxy = true;
                proxies = {
                    "all://" = "http://127.0.0.1:8118";
                    # "socks5h" = "socks5h://localhost:9050";
                    # "http" = "http://127.0.0.1:8118";
                    # "https" = "http://127.0.0.1:8118";
                };
            };

            enabled_plugins = [
              "Basic Calculator"
              "Hash plugin"
              "Tor check plugin"
              "Open Access DOI rewrite"
              "Hostnames plugin"
              "Unit converter plugin"
              "Tracker URL remover"
              "User Agent"
            ];

            engines = lib.mapAttrsToList (name: value: { 
                inherit name; 
                # request_timeout = lib.mkDefault 10.0;
            } // value) {
                "duckduckgo".disabled = true;
                "brave".disabled = true;
                "bing".disabled = false;
                "mojeek".disabled = true;
                "mwmbl" = {
                    disabled = false;
                    weight = 0.4;
                };
                "qwant".disabled = true;
                "crowdview" = {
                    disabled = false;
                    weight = 0.5;
                };
                "curlie".disabled = true;
                "ddg definitions" = {
                    disabled = false;
                    weight = 2;
                };
                "wikibooks".disabled = false;
                "wikidata".disabled = false;
                "wikiquote".disabled = true;
                "wikisource".disabled = true;
                "wikispecies" = {
                    disabled = false;
                    weight = 0.5;
                };
                "wikiversity" = {
                    disabled = false;
                    weight = 0.5;
                };
                "wikivoyage" = {
                    disabled = false;
                    weight = 0.5;
                };
                "currency".disabled = true;
                "dictzone".disabled = true;
                "lingva".disabled = true;
                "bing images".disabled = false;
                "brave.images".disabled = true;
                "duckduckgo images".disabled = true;
                "google images".disabled = false;
                "qwant images".disabled = true;
                "1x".disabled = true;
                "artic".disabled = false;
                "deviantart".disabled = false;
                "flickr".disabled = true;
                "imgur".disabled = false;
                "library of congress".disabled = false;
                "material icons" = {
                    disabled = false;
                    weight = 0.2;
                };
                "openverse".disabled = false;
                "pinterest".disabled = true;
                "svgrepo".disabled = false;
                "unsplash".disabled = false;
                "wallhaven".disabled = false;
                "wikicommons.images".disabled = false;
                "yacy images".disabled = true;
                "bing videos".disabled = false;
                "brave.videos".disabled = true;
                "duckduckgo videos".disabled = true;
                "google videos".disabled = false;
                "qwant videos".disabled = false;
                "dailymotion".disabled = true;
                "google play movies".disabled = true;
                "invidious".disabled = false;
                "odysee".disabled = false;
                "peertube".disabled = false;
                "piped".disabled = true;
                "rumble".disabled = true;
                "sepiasearch".disabled = false;
                "vimeo".disabled = true;
                "youtube".disabled = false;
                "brave.news".disabled = true;
                "google news".disabled = true;
            };
        };
    };
    
}

{lib, ...}: feeds: let
  inherit (lib.attrsets) attrValues mapAttrs;
in {
  type = "group";
  widgets = attrValues (mapAttrs (title: sources: {
      inherit title;
      type = "rss";
      hide-categories = true;
      feeds =
        map (source: {
          url = source;
        })
        sources;
    })
    feeds);
}

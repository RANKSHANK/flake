{lib, ...}: feeds: {
  type = "group";
  widgets = builtins.attrValues (builtins.mapAttrs (title: sources: {
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

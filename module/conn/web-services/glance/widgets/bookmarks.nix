{config, ...}: {
  type = "bookmarks";
  groups = [
    {
      name = "";
      links =
        map (link: {
          title = link.name;
          inherit (link) url;
        })
        config.browsers.bookmarks;
    }
  ];
}

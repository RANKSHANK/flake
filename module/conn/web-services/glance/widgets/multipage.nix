{lib, ...}: widg: {
  type = "group";
  widgets = builtins.attrValues (builtins.mapAttrs (title: sources: {
    inherit title;
  }));
}

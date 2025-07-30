{lib, ...}: widg: let
  inherit (lib.attrsets) attrValues mapAttrs;
in {
  type = "group";
  widgets = attrValues (mapAttrs (title: sources: {
    inherit title;
  }));
}

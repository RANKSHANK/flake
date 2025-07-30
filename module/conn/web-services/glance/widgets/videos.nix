{lib, ...}: channels: let
  inherit (lib.attrsets) attrValues;
in {
  channels = attrValues channels;
  type = "videos";
  style = "grid-cards";
  collapse-after-rows = 2;
}

{ ... }:

channels: {
    channels = builtins.attrValues channels;
    type = "videos";
    style = "grid-cards";
    collapse-after-rows = 2;
}

{
  inputs,
  pkgs,
  ...
}:
builtins.attrValues {
  inherit
    (inputs.hyprland-plugins.packages.${pkgs.system})
    ;
}

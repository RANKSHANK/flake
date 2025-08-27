{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.stylix.inputs) base16;
  colors = (mk-scheme-attrs (pkgs.callPackage ../../module/theme/scheme.nix {})).withHashtag;
  mk-scheme-attrs = (pkgs.callPackage base16.lib {}).mkSchemeAttrs;
in /* qml */ pkgs.writeText "Theme.qml" ''
  pragma Singleton
  import Quickshell
  import QtQuick

  Singleton {
    readonly property color base00: "${colors.base00}"
    readonly property color base01: "${colors.base01}"
    readonly property color base02: "${colors.base02}"
    readonly property color base03: "${colors.base03}"
    readonly property color base04: "${colors.base04}"
    readonly property color base05: "${colors.base05}"
    readonly property color base06: "${colors.base06}"
    readonly property color base07: "${colors.base07}"
    readonly property color base08: "${colors.base08}"
    readonly property color base09: "${colors.base09}"
    readonly property color base0A: "${colors.base0A}"
    readonly property color base0B: "${colors.base0B}"
    readonly property color base0C: "${colors.base0C}"
    readonly property color base0D: "${colors.base0D}"
    readonly property color base0E: "${colors.base0E}"
    readonly property color base0F: "${colors.base0F}"

    readonly property color borderFocused: base02
    readonly property color borderHovered: base05
    readonly property color borderUnfocused: base03
    readonly property color borderUnfocusedAlt: base01
    readonly property color backgroundFocused: base03
    readonly property color backgroundHovered: base02
    readonly property color backgroundUnfocused: base00
    readonly property color backgroundUnfocusedAlt: base01

    readonly property color text: base05
    readonly property color textAlt: base04
    readonly property color warning: base0A
    readonly property color urgent: base09
    readonly property color error: base08
  }
''

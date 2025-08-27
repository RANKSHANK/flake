{
  config,
  lib,
  util,
  ...
}: let
  inherit (lib.attrsets) filterAttrs mapAttrs;
  inherit (lib.strings) hasPrefix stringLength;
  inherit (lib.trivial) toHexString;
  inherit (util) hexToRgb mixRgb rgbToDec;
  rgbToHex = rgb: toHexString (rgbToDec rgb);
  rgb = mapAttrs (_: hexToRgb) (filterAttrs (name: _: (stringLength name == 6 && hasPrefix "base" name)) config.lib.stylix.colors);
  dec = mapAttrs (_: c: "${toString c.r}${toString c.g}${toString c.b}") rgb;
  hex = config.lib.stylix.colors.withHashtag;
  white-rgb = { r = 255; g = 255; b = 255; };
  gray-rgb = { r = 127; g = 127; b = 127; };
  mixColors = c1: c2: pct: rgbToHex (mixRgb c1 c2 pct);
  olive = mixColors rgb.base0F rgb.base0B 0.25;
  gray-brown = mixColors rgb.base0F gray-rgb 0.25;
  red-brown = mixColors rgb.base0F rgb.base08 0.25;
  light-red-brown = mixColors (hexToRgb red-brown) white-rgb 0.25;
in /* xml */''
<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<FCParameters>

  <FCParamGroup Name="Root">
    <FCParamGroup Name="BaseApp">
      <FCParamGroup Name="Preferences">
        <FCParamGroup Name="Editor">
          <FCUInt Name="Text" Value="${dec.base05}"/>
          <FCUInt Name="Bookmark" Value="${dec.base06}"/>
          <FCUInt Name="Breakpoint" Value="${dec.base0C}"/>
          <FCUInt Name="Keyword" Value="${dec.base08}"/>
          <FCUInt Name="Comment" Value="${dec.base03}"/>
          <FCUInt Name="Block comment" Value="${dec.base03}"/>
          <FCUInt Name="Number" Value="${dec.base09}"/>
          <FCUInt Name="String" Value="${dec.base0B}"/>
          <FCUInt Name="Character" Value="${dec.base09}"/>
          <FCUInt Name="Class name" Value="${dec.base0A}"/>
          <FCUInt Name="Define name" Value="${dec.base0E}"/>
          <FCUInt Name="Operator" Value="${dec.base05}"/>
          <FCUInt Name="Python output" Value="${dec.base05}"/>
          <FCUInt Name="Python error" Value="${dec.base08}"/>
          <FCUInt Name="Current line highlight" Value="${dec.base02}"/>
        </FCParamGroup>
        <FCParamGroup Name="OutputWindow">
          <FCUInt Name="colorText" Value="${dec.base05}"/>
          <FCUInt Name="colorLogging" Value="${dec.base06}"/>
          <FCUInt Name="colorWarning" Value="${dec.base0A}"/>
          <FCUInt Name="colorError" Value="${dec.base08}"/>
        </FCParamGroup>
        <FCParamGroup Name="View">
          <FCUInt Name="BackgroundColor" Value="${dec.base00}"/>
          <FCUInt Name="BackgroundColor2" Value="${dec.base01}"/>
          <FCUInt Name="BackgroundColor3" Value="${dec.base02}"/>
          <FCUInt Name="BackgroundColor4" Value="${dec.base03}"/>
          <FCBool Name="Simple" Value="0"/>
          <FCBool Name="Gradient" Value="1"/>
          <FCBool Name="UseBackgroundColorMid" Value="0"/>
          <FCUInt Name="HighlightColor" Value="3302296063"/>
          <FCUInt Name="SelectionColor" Value="1651680511"/>
          <FCUInt Name="DefaultShapeColor" Value="3435973887"/>
          <FCBool Name="RandomColor" Value="0"/>
          <FCUInt Name="DefaultShapeLineColor" Value="421075455"/>
          <FCUInt Name="DefaultShapeVertexColor" Value="421075455"/>
          <FCUInt Name="BoundingBoxColor" Value="4294967295"/>
          <FCUInt Name="AnnotationTextColor" Value="3402287871"/> 
          <FCUInt Name="SketchEdgeColor" Value="${dec.base05}"/>
          <FCUInt Name="SketchVertexColor" Value="${dec.base08}"/>
          <FCUInt Name="EditedEdgeColor" Value="4177064703"/>
          <FCUInt Name="EditedVertexColor" Value="4283782655"/>
          <FCUInt Name="ConstructionColor" Value="1803681791"/>
          <FCUInt Name="ExternalColor" Value="4286170879"/>
          <FCUInt Name="FullyConstrainedColor" Value="1358593023"/>
          <FCUInt Name="InternalAlignedGeoColor" Value="2998042623"/>
          <FCUInt Name="FullyConstraintElementColor" Value="2161156351"/>
          <FCUInt Name="FullyConstraintConstructionElementColor" Value="2695823359"/>
          <FCUInt Name="FullyConstraintInternalAlignmentColor" Value="3739142399"/>
          <FCUInt Name="FullyConstraintConstructionPointColor" Value="4288651263"/>
          <FCUInt Name="ConstrainedIcoColor" Value="4283782655"/>
          <FCUInt Name="NonDrivingConstrDimColor" Value="1803681791"/>
          <FCUInt Name="ConstrainedDimColor" Value="4283782655"/>
          <FCUInt Name="ExprBasedConstrDimColor" Value="4290276607"/>
          <FCUInt Name="DeactivatedConstrDimColor" Value="2139062271"/>
          <FCUInt Name="InvalidSketchColor" Value="4290276607"/>
          <FCUInt Name="CursorTextColor" Value="4177064703"/>
          <FCUInt Name="CursorCrosshairColor" Value="4294967295"/>
          <FCUInt Name="CreateLineColor" Value="4294967295"/>
          <FCUInt Name="ShadowLightColor" Value="${dec.base05}"/>
          <FCUInt Name="ShadowGroundColor" Value="${dec.base00}"/>
          <FCUInt Name="HiddenLineColor" Value="0"/>
          <FCUInt Name="HiddenLineFaceColor" Value="${dec.base07}"/>
          <FCUInt Name="HiddenLineBackground" Value="${dec.base07}"/>
        </FCParamGroup>
        <FCParamGroup Name="TreeView">
          <FCUInt Name="TreeEditColor" Value="${dec.base02}"/>
          <FCUInt Name="TreeActiveColor" Value="${dec.base03}"/>
        </FCParamGroup>
        <FCParamGroup Name="MainWindow">
          <!-- <FCText Name="StyleSheet">Stylix.qss</FCText> -->
        </FCParamGroup>
        <FCParamGroup Name="Mod">
          <FCParamGroup Name="Arch">
            <FCUInt Name="ColorHelpers" Value="${dec.base0C}"/>
            <FCUInt Name="defaultSpaceColor" Value="${dec.base08}"/>
            <FCUInt Name="PanelColor" Value="${olive}"/>
            <FCUInt Name="RebarColor" Value="${red-brown}"/>
            <FCUInt Name="StructureColor" Value="${gray-brown}"/>
            <FCUInt Name="WallColor" Value="${light-red-brown}"/>
            <FCUInt Name="WindowColor" Value="${dec.base0D}"/>
            <FCUInt Name="WindowGlassColor" Value="${dec.base0C}"/>
          </FCParamGroup>
          <FCParamGroup Name="Start">
            <FCUInt Name="BackgroundColor1" Value="${dec.base00}"/>
            <FCUInt Name="BackgroundTextColor" Value="${dec.base05}"/>
            <FCUInt Name="PageColor" Value="${dec.base01}"/>
            <FCUInt Name="PageTextColor" Value="${dec.base06}"/>
            <FCUInt Name="BoxColor" Value="${dec.base02}"/>
            <FCUInt Name="LinkColor" Value="${dec.base04}"/>
            <FCUInt Name="BackgroundColor2" Value="${dec.base01}"/>
          </FCParamGroup>
          <FCParamGroup Name="Spreadsheet">
            <FCText Name="AliasedCellBackgroundColor">${hex.base00}</FCText>
            <FCText Name="TextColor">${hex.base05}</FCText>
            <FCText Name="PositiveNumberColor">${hex.base05}</FCText>
            <FCText Name="NegativeNumberColor">${hex.base05}</FCText>
          </FCParamGroup>
        </FCParamGroup>
      </FCParamGroup>
    </FCParamGroup>
  </FCParamGroup>
</FCParameters>
''

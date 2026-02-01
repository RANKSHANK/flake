{
  lib,
  enables ? {
    disabledModules = [];
    enabledModules = [];
    enabledTags = [];
  },
  ...
}: let
  inherit (builtins) ceil isPath readDir trace typeOf;
  inherit (lib.attrsets) hasAttr filterAttrs mapAttrsToList;
  inherit (lib.lists) all any concatLists count elem filter foldl foldl' genList head last length zipLists;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.meta) hiPrio;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.strings) concatStringsSep hasSuffix removeSuffix replaceStrings splitString stringToCharacters stringLength substring toUpper;
  inherit (lib.trivial) floor min max pathExists pipe readFile seq throwIf;
in rec {
  ternary = bool: pass: fail:
    if bool
    then pass
    else fail;

  safeTypeOf = target: attrs: ternary (hasAttr target attrs) (typeOf attrs.${target}) "DNE";

  safeIsType = accept: target: attrs: accept == safeTypeOf target attrs;

  safeIsBool = safeIsType "bool";

  safeIsInt = safeIsType "int";

  safeIsString = safeIsType "string";

  safeIsPath = safeIsType "path";

  safeIsSet = safeIsType "set";

  safeIsList = safeIsType "list";

  safeIsFloat = safeIsType "float";

  safeLast = target: nul: ternary (safeIsList target && count target) (last target) nul;

  hasAny = targetList: sourceList: any (targ: elem targ sourceList) targetList;

  hasAll = targetList: sourceList: all (targ: elem targ sourceList) targetList;

  pipeAssert = init: funcs: (foldl' (acc: func: ternary (acc == false) false (ternary ((func acc) == false) false acc)) init funcs) != false;

  pipeAssertChained = init: funcs: (foldl' (acc: func: ternary (acc == false) false (func acc)) init funcs) != false;

  getModuleName = path:
    pipe path [
      toString
      (str: removeSuffix ".nix" str)
      (str: splitString "/" str)
      (strs: last strs)
    ];

  kebabCaseToCamelCase = str:
    pipe str [
      (splitString "-")
      (strs:
        foldl (acc: str:
          acc
          + (
            if str != (head strs)
            then (toUpper (substring 0 1 str)) + (substring 1 (stringLength str) str)
            else str
          )) ""
        strs)
    ];

  readFileOrDefault = file: default: ternary (pathExists file) (removeSuffix "\n" (readFile file)) default;

  findTopLevelDirectories = dir:
    mapAttrsToList (
      file: type:
        ternary (type == "directory") file []
    ) (readDir dir);

  listTargetFilesRecursively = extension: dir: (filter (hasSuffix extension) (listFilesRecursive dir));

  listNixFilesRecursively = listTargetFilesRecursively ".nix";

  ezTrace = val: trace val val;

  patchDesktopEntry = pkgs: pkg: appName: from: to: let
    zipped = zipLists from to;
    sed-args = map ({
      fst,
      snd,
    }: "-e 's#${fst}#${snd}#g'")
    zipped;
    concat-args = concatStringsSep " " sed-args;
  in
    hiPrio (
      pkgs.runCommand "$patched-desktop-entry-for-${appName}" {} ''
        ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
        ${pkgs.gnused}/bin/sed ${concat-args} < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );

  walkString = string: splitter: foldl' (acc: str: concatLists [acc [(ternary (length acc > 0) "${last acc}.${str}" str)]]) [] (splitString splitter string);

  mkIfEnabled = moduleName: requiredTags: toMake: mkIf (isEnabled moduleName requiredTags) toMake;

  concatLines = concatStringsSep "\n";

  isEnabled = moduleName: requiredTags: !(elem moduleName enables.disabledModules) && (elem moduleName enables.enabledModules || elem moduleName enables.enabledTags || (ternary (requiredTags == []) false (all (tag: elem tag enables.enabledTags) requiredTags)));

  genNumStrs = num: str: genList (i: replaceStrings ["<num>"] [(toString i)] str) num;

  mkModule = moduleName: requiredTags: module: let
    filter = name: elem name ["options" "imports"];
    mkOpt = set: {
      options.modules.${moduleName}.enable = mkOption {
        description = "Enable flag module";
        default = set;
      };
    };
  in
    seq # Don't support top level configs as that may lead to issues with top level mkIf
    
    (throwIf (hasAttr "config" module) "lib.mkModule for ${moduleName} has unsupported top level config = {...};")
    (
      ternary (isEnabled moduleName requiredTags) ({
          config = filterAttrs (name: _: !(filter name)) module;
        }
        // mkOpt true) (mkOpt false)
    )
    // (filterAttrs (name: _: filter name) module);

  hexToInt = hex: let
    codes = {
      "#" = 0;
      "x" = 0;
      "X" = 0;
      "0" = 0;
      "1" = 1;
      "2" = 2;
      "3" = 3;
      "4" = 4;
      "5" = 5;
      "6" = 6;
      "7" = 7;
      "8" = 8;
      "9" = 9;
      "a" = 10;
      "b" = 11;
      "c" = 12;
      "d" = 13;
      "e" = 14;
      "f" = 15;
      "A" = 10;
      "B" = 11;
      "C" = 12;
      "D" = 13;
      "E" = 14;
      "F" = 15;
    };
  in
    foldl' (acc: char: acc * 16 + codes.${char}) 0 (stringToCharacters hex);

  hexToRgb = hex: {
    r = hexToInt (substring 0 2 hex);
    g = hexToInt (substring 2 2 hex);
    b = hexToInt (substring 4 2 hex);
  };

  hex2Vec4 = color: opacity: let
    rgb = hexToRgb color;
  in "vec4(${toString rgb.r}.0 / 255.0, ${toString rgb.g}.0 / 255.0, ${toString rgb.b}.0 /  255.0, ${toString opacity})";

  rgbToHsl = rgb: let
    r = rgb.r / 255.0;
    g = rgb.g / 255.0;
    b = rgb.b / 255.0;
    maxVal = max r (max g b);
    minVal = min r (min g b);
    delta = maxVal - minVal;
    average = (maxVal + minVal) / 2.0;
  in
    ternary (delta == 0.0) {
      hue = 0.0;
      saturation = 0.0;
      luminance = floor average;
    } {
      saturation = floor (delta / (ternary (average > 0.5) (2.0 - maxVal - minVal) (maxVal + minVal)) * 100.0);
      luminance = floor (average * 100.0);
      hue = floor (
        ternary (maxVal == r) ((g - b) / delta + (ternary (g < b) 6.0 0.0)) (
          ternary (maxVal == g) ((b - r) / delta + 2.0)
          ((r - g) / delta + 4.0)
        )
        * 60.0
      );
    };

  rgbToDec = rgb: rgb.r * 65536 + rgb.g * 256 + rgb.b;

  mixRgb = rgb1: rgb2: percent1: let
      percent2 = 1.0 - percent1;
    in {
      r = ceil (rgb1.r * percent1 + rgb2.r * percent2);
      g = ceil (rgb1.g * percent1 + rgb2.g * percent2);
      b = ceil (rgb1.b * percent1 + rgb2.b * percent2);
    };

  fromNpins = target: (import ./npins.nix { input = target; });
}

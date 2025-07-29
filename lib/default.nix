{
  lib,
  enables ? {
    disabledModules = [];
    enabledModules = [];
    enabledTags = [];
  },
  ...
}: let
  inherit lib;
in rec {
  ternary = bool: pass: fail:
    if bool
    then pass
    else fail;

  safeTypeOf = target: attrs: ternary (builtins.hasAttr target attrs) (builtins.typeOf attrs.${target}) "DNE";

  safeIsType = accept: target: attrs: accept == safeTypeOf target attrs;

  safeIsBool = safeIsType "bool";

  safeIsInt = safeIsType "int";

  safeIsString = safeIsType "string";

  safeIsPath = safeIsType "path";

  safeIsSet = safeIsType "set";

  safeIsList = safeIsType "list";

  safeIsFloat = safeIsType "float";

  safeLast = target: nul: ternary (safeIsList target && lib.count target) (lib.last target) nul;

  hasAny = targetList: sourceList: builtins.any (targ: builtins.elem targ sourceList) targetList;

  hasAll = targetList: sourceList: builtins.all (targ: builtins.elem targ sourceList) targetList;

  pipeAssert = init: funcs: (lib.foldl' (acc: func: ternary (acc == false) false (ternary ((func acc) == false) false acc)) init funcs) != false;

  pipeAssertChained = init: funcs: (lib.foldl' (acc: func: ternary (acc == false) false (func acc)) init funcs) != false;

  getModuleName = path:
    lib.pipe path [
      toString
      (str: lib.removeSuffix ".nix" str)
      (str: lib.splitString "/" str)
      (strs: lib.last strs)
    ];

  kebabCaseToCamelCase = str:
    lib.pipe str [
      (lib.splitString "-")
      (strs:
        lib.foldl (acc: str:
          acc
          + (
            if str != (builtins.head strs)
            then (lib.toUpper (builtins.substring 0 1 str)) + (builtins.substring 1 (builtins.stringLength str) str)
            else str
          )) ""
        strs)
    ];

  readFileOrDefault = file: default: ternary (builtins.pathExists file) (lib.removeSuffix "\n" (builtins.readFile file)) default;

  findTopLevelDirectories = dir:
    lib.mapAttrsToList (
      file: type:
        ternary (type == "directory") file []
    ) (builtins.readDir dir);

  listTargetFilesRecursively = extension: dir: (builtins.filter (lib.hasSuffix extension) (lib.filesystem.listFilesRecursive dir));

  listNixFilesRecursively = listTargetFilesRecursively ".nix";

  ezTrace = val: builtins.trace val val;

  patchDesktopEntry = pkgs: pkg: appName: from: to: let
    zipped = lib.zipLists from to;
    sed-args = builtins.map ({
      fst,
      snd,
    }: "-e 's#${fst}#${snd}#g'")
    zipped;
    concat-args = builtins.concatStringsSep " " sed-args;
  in
    lib.hiPrio (
      pkgs.runCommand "$patched-desktop-entry-for-${appName}" {} ''
        ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
        ${pkgs.gnused}/bin/sed ${concat-args} < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );

  walkString = string: splitter: lib.foldl' (acc: str: builtins.concatLists [acc [(ternary (builtins.length acc > 0) "${lib.last acc}.${str}" str)]]) [] (lib.splitString splitter string);

  mkIfEnabled = moduleName: requiredTags: toMake: lib.mkIf (isEnabled moduleName requiredTags) toMake;

  isEnabled = moduleName: requiredTags: !(builtins.elem moduleName enables.disabledModules) && (builtins.elem moduleName enables.enabledModules || builtins.elem moduleName enables.enabledTags || (ternary (requiredTags == []) false (builtins.all (tag: builtins.elem tag enables.enabledTags) requiredTags)));

  genNumStrs = num: str: builtins.genList (i: builtins.replaceStrings ["<num>"] [(toString i)] str) num;

  mkModule = moduleName: requiredTags: module: let
    filter = name: builtins.elem name ["options" "imports"];
    mkOpt = set: {
      options.modules.${moduleName}.enable = lib.mkOption {
        description = "Enable flag module";
        default = set;
      };
    };
  in
    builtins.seq # Don't support top level configs as that may lead to issues with top level mkIf
    
    (lib.throwIf (builtins.hasAttr "config" module) "lib.mkModule for ${moduleName} has unsupported top level config = {...};")
    (
      ternary (isEnabled moduleName requiredTags) ({
          config = lib.filterAttrs (name: _: !(filter name)) module;
        }
        // mkOpt true) (mkOpt false)
    )
    // (lib.filterAttrs (name: _: filter name) module);

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
    lib.foldl' (acc: char: acc * 16 + codes.${char}) 0 (lib.stringToCharacters hex);

  hexToRgb = hex: {
    r = hexToInt (builtins.substring 0 2 hex);
    g = hexToInt (builtins.substring 2 2 hex);
    b = hexToInt (builtins.substring 4 2 hex);
  };

  hex2Vec4 = color: opacity: let
    rgb = hexToRgb color;
  in "vec4(${toString rgb.r}.0 / 255.0, ${toString rgb.g}.0 / 255.0, ${toString rgb.b}.0 /  255.0, ${toString opacity})";

  rgbToHsl = rgb: let
    r = rgb.r / 255.0;
    g = rgb.g / 255.0;
    b = rgb.b / 255.0;
    maxVal = lib.max r (lib.max g b);
    minVal = lib.min r (lib.min g b);
    delta = maxVal - minVal;
    average = (maxVal + minVal) / 2.0;
  in
    ternary (delta == 0.0) {
      hue = 0.0;
      saturation = 0.0;
      luminance = builtins.floor average;
    } {
      saturation = builtins.floor (delta / (ternary (average > 0.5) (2.0 - maxVal - minVal) (maxVal + minVal)) * 100.0);
      luminance = builtins.floor (average * 100.0);
      hue = builtins.floor (
        ternary (maxVal == r) ((g - b) / delta + (ternary (g < b) 6.0 0.0)) (
          ternary (maxVal == g) ((b - r) / delta + 2.0)
          ((r - g) / delta + 4.0)
        )
        * 60.0
      );
    };

  isDecrypted = let
    file = ../${builtins.replaceStrings ["#SALT#" "\n"] ["" ""] (builtins.readFile ../.crypted.crypt.txt)};
  in
    builtins.isPath file && builtins.pathExists file;

  fromNpins = import ./npins.nix;
}

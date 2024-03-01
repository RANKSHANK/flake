{lib, ...}: let
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

  hasAny = targetList: sourceList: builtins.any (targ: builtins.elem targ sourceList) targetList;

  hasAll = targetList: sourceList: builtins.all (targ: builtins.elem targ sourceList) targetList;

  pipeAssert = init: funcs: (lib.foldl' (acc: func: ternary (acc == false) false (ternary ((func acc) == false) false acc)) init funcs) != false;

  pipeAssertChained = init: funcs: (lib.foldl' (acc: func: ternary (acc == false) false (func acc)) init funcs) != false;

  getModuleName = path:
    lib.pipe path [
      toString
      (str: lib.removeSuffix ".nix")
      (str: lib.splitString "/" path)
      (strs: lib.last strs)
    ];

    kebabCaseToCamelCase = str: lib.pipe str [
        (lib.splitString "-")
        (strs: lib.foldl (acc: str: acc + (if str != (builtins.head strs) then (lib.toUpper (builtins.substring 0 1 str)) + (builtins.substring 1 (builtins.stringLength str) str) else str)) "" strs)
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

  filterModules = lib.filter (module: (builtins.match "^.*(mk(Sub)?[Mm]odule).*$" (builtins.readFile module)) != null);

# This currently doesn't work, need to disable greedy regex matching, not sure if possible
  filterDisabledModules = modules: enableSet: let
    findModulesLine = builtins.match "^.*(mkModule.*?][[:s:]]*config).*$";
    findComponent = builtins.match "^.+(\"([a-zA-z0-9_-]*)\").*$";
    recurseComponents = modulesLine: lib.pipe modulesLine [
        (findComponent)
        (components: ternary (components != null && builtins.length components == 2) [
            (recurseComponents ((builtins.replaceStrings [(lib.head components)] [""] modulesLine)))
            (lib.last components)] [])
    ];
  in lib.pipe modules [
    (map (module: { # Check for modules by their module declaration lines
        inherit module;
        moduleDecl = findModulesLine (builtins.readFile module);
    }))
    (lib.filter (module: module.moduleDecl != null)) # Remove files w/out declarations
    (map (moduleWithDecl: rec { # break the declaration into components
        inherit (moduleWithDecl) module;
        components = lib.flatten (recurseComponents (lib.head (ezTrace moduleWithDecl.moduleDecl)));
        isSubmodule = ((builtins.match "^.*(mkSub[Mm]odule).*$" (lib.head moduleWithDecl.moduleDecl)) != null);
        moduleName = lib.tail (ezTrace components);
        moduleReqTags = lib.init components;
    }))
    (modulesWithTags: { # Run through the modules and gen a list of the enabled ones
        inherit modulesWithTags;
        enabledModules = lib.filter
            (moduleName: ternary
                (safeIsList "disabledModules" enableSet)
                (!builtins.elem moduleName moduleName)
                (true))
            (lib.flatten [
                (ternary
                    (safeIsList "enabledTags" enableSet)
                    (map
                        (moduleWithTags: ternary 
                            (moduleWithTags.moduleReqTags != [] && (hasAll (moduleWithTags.moduleReqTags) enableSet.enabledTags))
                            (moduleWithTags.moduleName)
                            []
                        ) modulesWithTags)
                    [])
                (ternary
                    (safeIsList "enabledModules" enableSet)
                    (enableSet.enabledModules)
                    [])
            ]);
    })
    (modulesWithEnables:  lib.flatten (map
        (module: ternary
            (builtins.elem (ezTrace module.moduleName) modulesWithEnables.enabledModules)
            (module.module)
            []
        )
        modulesWithEnables.modulesWithTags))
        ezTrace
  ];

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

  mkIfEnabled = str: config: set: lib.mkIf (isEnabled str config) set;

  isEnabled = moduleName: config: !(builtins.elem moduleName config.disabledModules) && (builtins.elem moduleName config.enabledModules || builtins.elem moduleName config.enabledTags || (ternary (builtins.hasAttr moduleName config.modules) (ternary (lib.count config.modules.${moduleName}.requiredTags == 0) false (builtins.all (tag: builtins.elem tag config.enabledTags) config.modules.${moduleName}.requiredTags))) false);

 genNumStrs = num: str: builtins.genList (i: builtins.replaceStrings ["<num>"] [(toString i)] str) num;

  # The same but marked for auto import TODO: does not split out options and imports properly
  mkSubmodule = mkIfEnabled;

  mkModule = moduleName: enableTags: config: module: let
    filter = name: builtins.elem name [ "options" "imports" ];
  in builtins.seq # Don't support top level configs as that may lead to issues with top level mkIf
    (lib.throwIf (builtins.hasAttr "config" module) "lib.mkModule for ${moduleName} has unsupported top level config = {...};")
    {
        options.modules.${moduleName}.requiredTags = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = enableTags;
            description = "Tags required for auto enabling ${moduleName}";
        };
        config = mkIfEnabled moduleName config (lib.filterAttrs (name: _: !(filter name)) module);
    } // (lib.filterAttrs (name: _: filter name) module);

}

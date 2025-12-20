{ lib, ... }@args:

let
  mkAttrOptionMatchingStr = str: let
    mapFn = name: val:
      lib.mkOption {
        default = val;
        type = lib.types.strMatching str;
      };
  in
    (colors: builtins.mapAttrs mapFn colors);
in
rec {
  mergeElse = set1: set2: elseFn: let
    conflicts = builtins.intersectAttrs set1 set2;
  in if conflicts == [] then set1 // set2 else elseFn conflicts;
  mergeElseThrow = set1: set2: let
    errMsgFn = conflicts: let
      conflictsStr = conflicts
        |> builtins.attrNames
        |> builtins.concatStringsSep ", ";
    in throw "Attribute conflict detected for keys: ${conflictsStr}";
  in mergeElse set1 set2 errMsgFn;

  selectExclusiveElse = set1: set2: elseFn:
    if set1 == {} || set1 == null then set2
    else if set2 == {} || set2 == null then set1
    else elseFn set1 set2;
  selectExclusiveElseThrow = set1: set2:
    selectExclusiveElse set1 set2 (_: _: throw "Both sets are non-empty");

  emptyIfNot = condition: attr:
    if condition then attr
    else {};

  _flattenAttrsRec = prefix: set: let
    concatFn = key: let
      value = set.${key};
      path = if prefix == "" then key else "${prefix}.${key}";
    in
      if builtins.isAttrs value && !lib.isDerivation value then
        _flattenAttrsRec path value
      else
        [ { inherit path value; } ];
  in
    lib.concatMap concatFn (builtins.attrNames set);
  flattenAttrs = _flattenAttrsRec "";

  mkColorsOption = mkAttrOptionMatchingStr "^(([0-9A-Za-z]{3})|([0-9A-Za-z]{6}))$";
  mkHashColorsOption = mkAttrOptionMatchingStr "^#(([0-9A-Za-z]{3})|([0-9A-Za-z]{6}))$";

  gtkCssDefineColors = let
    toList = colors: lib.attrsets.mapAttrsToList (k: v: "@define-color ${k} ${v};") colors;
  in colors: lib.strings.concatStringsSep "\n" (toList colors);

  importAll = args: paths: map (p: import p args) paths;

  styling = import ./styling.nix args;

  fromYAML = str: {}; # TODO
} 

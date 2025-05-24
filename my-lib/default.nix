{ lib, ... }:

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
{
  mkColorsOption = mkAttrOptionMatchingStr "^(([0-9A-Za-z]{3})|([0-9A-Za-z]{6}))$";
  mkHashColorsOption = mkAttrOptionMatchingStr "^#(([0-9A-Za-z]{3})|([0-9A-Za-z]{6}))$";

  gtkCssDefineColors = let
    toList = colors: lib.attrsets.mapAttrsToList (k: v: "@define-color ${k} ${v};") colors;
  in colors: lib.strings.concatStringsSep "\n" (toList colors);

  importAll = args: paths: map (p: import p args) paths;

  styling = import ./styling.nix;

  fromYAML = str: {}; # TODO
} 

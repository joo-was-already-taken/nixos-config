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

  fromYAML = str: {}; # TODO
} 

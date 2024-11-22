{ lib, ... }:

{
  mkColorsOption = defaultColors: let
    mapFn = name: val:
      lib.mkOption {
        default = val;
        type = lib.types.strMatching "^#(([0-9A-Za-z]{3})|([0-9A-Za-z]{6}))$";
      };
  in
    builtins.mapAttrs mapFn defaultColors;

  fromYAML = str: {}; # TODO
} 

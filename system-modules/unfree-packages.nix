{ lib, config, ... }:

{
  options.unfreePackages = lib.mkOption {
    type = with lib.types; listOf str;
    default = [];
    description = "List of allowed unfree packages";
  };

  config.nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) config.unfreePackages;
}

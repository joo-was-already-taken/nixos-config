{ lib, config, pkgs, ... }:
let
  moduleName = "dev";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = with pkgs; [
      poetry
    ];
  };
}

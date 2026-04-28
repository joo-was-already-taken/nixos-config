{ lib, config, ... }:
let
  moduleName = "yazi";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

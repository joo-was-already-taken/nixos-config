{ lib, config, ... }:
let
  moduleName = "qutebrowser";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    stylix.targets.qutebrowser.enable = false;
    programs.qutebrowser = {
      enable = true;
    };
  };
}

{ config, lib, ... }:
let
  moduleName = "emacs";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    services.emacs = {
      enable = true;
      startWithUserSession = true;
    };
    programs.doom-emacs = {
      enable = true;
      doomDir = ./doom;
    };
  };
}

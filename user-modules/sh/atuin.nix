{ lib, config, ... }:
let
  moduleName = "atuin";
  module = config.modules.${moduleName};
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption moduleName;
    enableZshIntegration = lib.mkEnableOption "zsh integration";
  };

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.atuin = {
      enable = true;
      inherit (module) enableZshIntegration;
      flags = [
        "--disable-up-arrow"
      ];
    };
  };
}

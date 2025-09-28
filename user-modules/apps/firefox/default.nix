{ lib, config, pkgs, ... }:
let
  moduleName = "firefox";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = [ pkgs.geckodriver ];

    stylix.targets.firefox = {
      enable = true;
      profileNames = [ "default" ];
    };

    programs.firefox = {
      enable = true;

      policies = (builtins.fromJSON (builtins.readFile ./policies.json)).policies;
    };
  };
}

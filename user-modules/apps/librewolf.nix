{ lib, config, ... }:
let
  moduleName = "librewolf";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.librewolf = {
      enable = true;

      settings = {
        "webgl.disabled" = false;
        "content.protectedContent" = true;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };
  };
}

{ config, lib, pkgs, ... }@args:
let
  moduleName = "eww";
  scripts = import ./scripts args;
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption moduleName;
    bar.enable = lib.mkEnableOption "enable bar widget";
  };

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = [
      pkgs.eww
      pkgs.jq
      scripts.hyprFullscreenMode
      scripts.hyprListen
      scripts.battery
    ];

    home.file.".config/eww" = {
      source = ./bar;
      recursive = true;
    };
  };
}

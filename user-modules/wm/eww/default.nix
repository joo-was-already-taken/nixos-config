{ config, lib, myLib, pkgs, ... }@args:
let
  moduleName = "eww";
  scripts = import ./scripts args;
  defaultColors = with config.lib.stylix.colors.withHashtag; {
    volume = base0E;
    brightness = base0A;
    battery = base0B;
  };
  colors = config.modules.${moduleName}.colors;
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption moduleName;
    bar.enable = lib.mkEnableOption "enable bar widget";
    colors = myLib.mkHashColorsOption defaultColors;
  };

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = [
      pkgs.eww
      pkgs.jq
      scripts.hyprFullscreenMode
      scripts.hyprListen
      scripts.hyprWorkspaces
      scripts.battery

      scripts.pulseVolume

      # fonts
      pkgs.nerd-fonts.jetbrains-mono
    ];

    fonts.fontconfig.enable = true;

    home.file.".config/eww/eww.yuck".source = ./bar/eww.yuck;
    home.file.".config/eww/eww.scss".text =
      (myLib.scssDefineColors colors) + "\n" + builtins.readFile ./bar/eww.scss;
  };
}

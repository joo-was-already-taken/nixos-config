{ myLib, pkgs, lib, config, ... }:
let
  moduleName = "rofi";
  defaultColors = let
    stylixColors = config.lib.stylix.colors.withHashtag;
  in {
    background = stylixColors.base00;
    foreground = stylixColors.base06;
    selectedBackground = stylixColors.base0B;
    selectedForeground = stylixColors.base00;
    urgentBackground = stylixColors.base08;
    selectedUrgentBackground = stylixColors.base0A;
    border = stylixColors.base0C;
  };
  enabledTerminalPath = let
    term = lib.findFirst (term: config.modules.${term}.enable) null [
      "ghostty"
      "alacritty"
    ];
  in "${pkgs.${term}}/bin/${term}";
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption "rofi-wayland";
    colors = myLib.mkHashColorsOption defaultColors;
  };

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = with pkgs; [
      rofi-wayland
    ];
    home.file.".config/rofi/config.rasi".text = let
      settings = ''
        configuration {
          terminal: "${enabledTerminalPath}";
        }
      '';
      styling = with config.modules.${moduleName}.colors; ''
        * {
          font: "${config.stylix.fonts.monospace.name} 15px";
          background: ${background};
          foreground: ${foreground};
          active-background: ${selectedBackground};
          selected-normal-background: ${selectedBackground};
          urgentBackground: ${urgentBackground};
          selected-urgent-background: ${urgentBackground};
          selected-active-background: ${urgentBackground};
        }
        window {
          border-color: ${border};
        }
      '';
    in settings + styling + (builtins.readFile ./config.rasi);
  };
}

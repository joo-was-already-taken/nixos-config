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
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption "rofi-wayland";
    
    colors = myLib.mkColorsOptions defaultColors;
  };

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = with pkgs; [
      rofi-wayland
    ];
    home.file.".config/rofi/config.rasi".text = let
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
    in styling + (builtins.readFile ./config.rasi);
  };
}

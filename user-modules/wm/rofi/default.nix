{ pkgs, lib, config, ... }:
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
  mkColorsOptions = defaultColors: let
    mapFn = name: val:
      lib.mkOption {
        default = val;
        type = lib.types.strMatching "^#(([0-9A-Za-z]{3})|([0-9A-Za-z]{6}))$";
      };
  in
    builtins.mapAttrs mapFn defaultColors;
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption "rofi-wayland";
    
    colors = mkColorsOptions defaultColors;
  };

  config = {
    modules.${moduleName}.enable = lib.mkDefault true;

    home = lib.mkIf config.modules.${moduleName}.enable {
      packages = with pkgs; [
        rofi-wayland
      ];
      file.".config/rofi/config.rasi".text = let
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
  };
}

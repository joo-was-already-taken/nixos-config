{ pkgs, config, lib, myLib, ... }:
let
  moduleName = "ironbar";
  defaultColors = with config.lib.stylix.colors.withHashtag; rec {
  };
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption moduleName;
    colors = myLib.mkHashColorsOption defaultColors;
  };

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = with pkgs; [
      ironbar
      upower
      nerd-fonts.iosevka-term-slab
    ];

    fonts.fontconfig.enable = true;

    home.file.".config/ironbar/style.css".source = ./style.css;
    home.file.".config/ironbar/config.json".text = builtins.toJSON {
      position = "top";
      height = 28;
      start = [ { type = "workspaces"; } ];
      center = [];
      end = [
        {
          type = "tray";
          prefer_theme_icons = false;
        }
        { type = "upower"; }
        {
          type = "clock";
          format = "%H:%M";
        }
      ];
    };
  };
}

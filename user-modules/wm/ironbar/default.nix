{ pkgs, config, lib, myLib, ... }@args:
let
  moduleName = "ironbar";
  defaultColors = with config.lib.stylix.colors.withHashtag; rec {
  };
  scripts = import ./scripts args;
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption moduleName;
    colors = myLib.mkHashColorsOption defaultColors;
  };

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = with pkgs; [
      ironbar
      nerd-fonts.jetbrains-mono
    ];

    fonts.fontconfig.enable = true;

    home.file.".config/ironbar/style.css".source = ./style.css;
    home.file.".config/ironbar/config.json".text = builtins.toJSON {
      position = "top";
      height = 24;
      start = [ { type = "workspaces"; } ];
      center = [
        {
          type = "clock";
          format = "%H:%M";
          format_popup = "%d/%m/%Y %H:%M:%S";
        }
      ];
      end = [
        { type = "volume"; }
        { type = "network_manager"; }
        {
          # CPU percentage
          type = "label";
          label = '' {{poll:5000:top -bn2 | awk '/^%Cpu/ {printf("%.1f\n", 100 - $8); exit}'}}%'';
        }
        {
          # Memory usage
          type = "label";
          label = " {{poll:5000:${lib.getExe scripts.memory}}} GiB";
        }
        { type = "upower"; }
        {
          type = "tray";
          prefer_theme_icons = true;
        }
      ];
    };
  };
}

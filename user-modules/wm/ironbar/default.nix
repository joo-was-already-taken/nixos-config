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
    home.packages = [
      pkgs.ironbar
      pkgs.upower
      pkgs.nerd-fonts.iosevka-term-slab
    ];

    fonts.fontconfig.enable = true;

    home.file.".config/ironbar/style.css".source = ./style.css;
    home.file.".config/ironbar/config.json".text = builtins.toJSON {
      position = "top";
      height = 28;
      start = [ { type = "workspaces"; } ];
      center = [ { type = "clock"; } ];
      end = [
        { type = "volume"; }
        { type = "network_manager"; }
        {
          type = "sys_info";
          format = [ " {cpu_percent@sum: <4}%" ];
        }
        {
          type = "label";
          label = " {{poll:5000:${lib.getExe scripts.memory}}}";
        }
        # { type = "upower"; }
        {
          type = "tray";
          prefer_theme_icons = false;
        }
      ];
    };
  };
}

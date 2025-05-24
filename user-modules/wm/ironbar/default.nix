{ pkgs, config, lib, myLib, ... }@args:
let
  moduleName = "ironbar";
  defaultColors = with config.lib.stylix.colors.withHashtag; {
    bar_bg = base00;

    workspaces = base06;

    clock_fg = base01;
    clock_bg = base05;

    volume = base09;
    cpu = base0A;
    memory = base0E;
    battery = base0C;

    tray_bg = base01;
  };
  scripts = import ./scripts args;
  colors = config.modules.${moduleName}.colors;
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption moduleName;
    colors = myLib.mkHashColorsOption defaultColors;
  };

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = with pkgs; [
      ironbar
      nerd-fonts.jetbrains-mono
      scripts.displayHyprWorkspaces
    ];

    fonts.fontconfig.enable = true;

    home.file.".config/ironbar/style.css".text =
      (myLib.gtkCssDefineColors colors) + "\n" + builtins.readFile ./style.css;

    home.file.".config/ironbar/config.json".text = builtins.toJSON {
      position = "top";
      height = 24;
      start = [
        {
          # Hyprland workspaces
          type = "script";
          class = "custom-workspaces";
          cmd = lib.getExe scripts.displayHyprWorkspaces;
          mode = "watch";
        }
      ];
      center = [
        {
          type = "clock";
          format = "%H:%M";
          format_popup = "%d/%m/%Y %H:%M:%S";
        }
      ];
      end = [
        # {
        #   type = "keyboard";
        #   show_caps = true;
        #   show_num = false;
        #   show_scroll = false;
        #   show_layout = true;
        # }
        { type = "volume"; }
        {
          # CPU percentage
          type = "label";
          class = "custom-cpu";
          label = '' {{poll:5000:top -bn2 | awk '/^%Cpu/ {printf("%.1f\n", 100 - $8); exit}'}}%'';
        }
        {
          # Memory usage
          type = "label";
          class = "custom-memory";
          label = " {{poll:5000:${lib.getExe scripts.memory}}} GiB";
        }
        {
          type = "script";
          class = "custom-battery";
          cmd = lib.getExe scripts.battery;
          mode = "poll";
          interval = 10000;
        }
        {
          type = "tray";
          icon_size = 14;
          prefer_theme_icons = true;
        }
      ];
    };
  };
}

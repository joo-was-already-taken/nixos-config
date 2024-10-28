{ config, lib, myLib, ... }:
let
  moduleName = "waybar";
  defaultColors = with config.lib.stylix.colors.withHashtag; rec {
    foreground = base07;
    foregroundDim = base04;
    background = base00;

    activeWorkspace = base0A;
    inactiveWorkspace = base04;
    emptyWorkspace = base02;
    urgentWorkspace = base08;

    submap = base08;

    windowName = foreground;

    clock = foreground;

    battery = base0B;
    batteryWarning = base09;
    batteryCritical = base08;

    sound = base0A;
    soundMuted = foregroundDim;

    memory = base0C;
    temperature = base09;
    cpu = base0E;

    keyboardStateActive = base0B;
    keyboardStateInactive = foregroundDim;

    tray = base01;
  };
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption moduleName;
    
    colors = myLib.mkColorsOption defaultColors;
  };

  config = lib.mkIf config.modules.${moduleName}.enable {
    stylix.targets.waybar.enable = false;

    programs.waybar = {
      enable = true;

      style = let
        font = /*css*/ ''
          * {
            font-family: "${config.stylix.fonts.monospace.name}";
          }
        '';
      in lib.strings.concatStringsSep "\n" (
        (lib.attrsets.mapAttrsToList (k: v: "@define-color ${k} ${v};") config.modules.${moduleName}.colors)
        ++ [ font (builtins.readFile ./style.css) ]
      );

      settings.mainBar = {
        reload_style_on_change = true;
        layer = "top";
        position = "top";
        height = 34;
        spacing = 0;
        fixed-center = true;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "tray"
          "keyboard-state"
          # "network"
          "cpu"
          "temperature"
          "memory"
          "pulseaudio"
          "battery"
          "clock"
        ];
        "hyprland/window" = {
          format = "{}";
          rewrite = {
            "(.*) LibreWolf" = "LibreWolf";
            "(.*) Firefox" = "Firefox";
            "(.*) qutebrowser" = "qutebrowser";
            "(.*) VSCodium" = "VSCodium";
          };
        };
        "hyprland/submap" = {
          format = "[{}]";
          tooltip = true;
        };
        keyboard-state = {
          capslock = true;
          format = "{name}{icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        cpu = {
          interval = 10;
          format = " {usage}%";
        };
        temperature = {
          interval = 30;
          format = " {temperatureC}°C";
        };
        memory = {
          interval = 30;
          format = " {}%";
          max-length = 10;
        };
        # network = {
        #   format-disconnected = " ";
        #   format-ethernet = "󱘖 {ifname}";
        #   format-linked = "󱘖 {ifname} (No IP)";
        #   format-wifi = " {essid} ({signalStrength}%)";
        #   interval = 5;
        #   tooltip-format = "{ifname}  {bandwidthUpBytes}  {bandwidthDownBytes}";
        #   max-length = 16;
        # };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon}  {volume}%";
          format-muted = " {volume}%";
          format-icons = {
            # "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
            # "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
            headphones = "";
            # handsfree = "";
            headset = "";
            phone = "";
            phone-muted = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
        };
        battery = {
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          states = {
            warning = 30;
            critical = 10;
          };
          interval = 30;
        };
        "hyprland/workspaces" = {
          all-outputs = true;
          active-only = false;
          show-special = true;
          format = "{icon}";
          format-icons = {
            "1" = "I";
            "2" = "II";
            "3" = "III";
            "4" = "IV";
            "5" = "V";
            "6" = "VI";
            "7" = "VII";
            "8" = "VIII";
            "9" = "IX";
            "10" = "X";
            # active = "";
            # default = "";
            # urgent = "";
          };
          persistent-workspaces."*" = 10;
          on-click = "activate";
        };
      };
    };
  };
}

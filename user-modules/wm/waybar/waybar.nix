{ pkgs, config, lib, ... }:
let
  colors = with config.lib.stylix.colors.withHashtag; {
    bg = base00;
    fg-dim = base04;
    fg = base07;
    red = base08;
    orange = base09;
    yellow = base0A;
    green = base0B;
    cyan = base0C;
    blue = base0D;
    purple = base0E;
  };
in {
  stylix.targets.waybar.enable = false;

  programs.waybar = {
    enable = true;

    style = lib.strings.concatStringsSep "\n" (
      (lib.attrsets.mapAttrsToList (k: v: "@define-color ${k} ${v};") colors)
      ++ [
        ''
          * {
            font-family: "${config.stylix.fonts.monospace.name}";
          }
        ''
        (builtins.readFile ./style.css)
      ]
    );

    settings = {
      mainBar = {
        reload_style_on_change = true;
        layer = "top";
        position = "top";
        height = 26;
        spacing = 0;
        fixed-center = true;

        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "keyboard-state"
          "network"
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
            "(.*) Mozilla Firefox" = "Mozilla Firefox";
          };
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
        network = {
          format-disconnected = " ";
          format-ethernet = "󱘖 {ifname}";
          format-linked = "󱘖 {ifname} (No IP)";
          format-wifi = " {essid} ({signalStrength}%)";
          interval = 5;
          tooltip-format = "{ifname}  {bandwidthUpBytes}  {bandwidthDownBytes}";
          max-length = 16;
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-bluetooth = "{icon}  {volume}%";
          format-muted = " {volume}%";
          format-icons = {
            "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
            "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
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
        };
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            active = "";
            default = "";
            urgent = "";
          };
          on-click = "activate";
        };
      };
    };
  };
}

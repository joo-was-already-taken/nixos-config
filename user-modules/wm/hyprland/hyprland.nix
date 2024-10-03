{ pkgs, lib, inputs, ... }:

{
  imports = [
    ../../apps/alacritty.nix
  ];

  home.packages = with pkgs; [
    # for waybar, see [./waybar.css]
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  fonts.fontconfig.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  services.hyprpaper = let
    wallpaper = "~/nixos-config/styling/wallpapers/tstudler_switzerland.jpg";
  in {
    enable = true;
    settings = {
      preload = [ wallpaper ];
      wallpaper = [ ",${wallpaper}" ];
    };
  };

  programs.waybar = {
    enable = true;

    style = builtins.readFile ./waybar.css;

    settings = {
      mainBar = {
        reload_style_on_change = true;
        layer = "top";
        position = "top";
        height = 20;
        spacing = 0;
        fixed-center = false;

        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "tray"
          # "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "battery"
          "clock"
        ];
        # pulseaudio = {
        #   on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +1%";
        #   on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -1%";
        # };
        battery = {
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

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    plugins = [];

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "";
      "$webBrowser" = "firefox";
      "$menu" = "wofi --show drun";

      exec-once = [
        "waybar &"
      ];

      env = [
        "XCURSOR_SIZE, 24"
        "HYPRCURSOR_SIZE, 24"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;

        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = false;

        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";

        blur = {
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      input = {
        kb_layout = "pl";

        follow_mouse = 1;

        sensitivity = 0;

        touchpad = {
          natural_scroll = false;
        };
      };

      gestures = {
        workspace_swipe = false;
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      windowrulev2 = "suppressevent maximize, class:.*";

      bind = [
        "$mod, F, exec, $webBrowser"
        "$mod, Q, exec, $terminal"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating"
        "$mod, R, exec, $menu"
        # "$mod, P, pseudo"
        "$mod, J, togglesplit"

        # sound controls
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"

        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        "$mod, N, workspace, +1"
        "$mod, P, workspace, -1"
      ] ++ ( # generate workspace bindings for workspaces 1 - 9
          let
            bindWorkspace = ws: let
              idx = ws - 1;
            in [
              "$mod, code:1${toString idx}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString idx}, movetoworkspace, ${toString ws}"
            ];
          in
            builtins.concatLists (builtins.genList (idx: bindWorkspace (idx + 1)) 9)
        );
    };
  };
}

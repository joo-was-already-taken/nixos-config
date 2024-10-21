{ pkgs, lib, inputs, config, systemSettings, sessionVariables, ... }:
let
  moduleName = "hyprland";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = with pkgs; [
      inputs.pyprland.packages.${systemSettings.system}.pyprland
      pulseaudio
      wlr-randr
      hyprshot
      brightnessctl
      networkmanagerapplet
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        # xdg-desktop-portal-kde # waybar doesn't work with this enabled
      ];
      config.common.default = "*";
    };

    services.hyprpaper = let
      wallpaper = builtins.toString config.stylix.image;
    in {
      enable = true;
      settings = {
        preload = [ wallpaper ];
        wallpaper = [ ", ${wallpaper}" ];
      };
    };

    home.file.".config/hypr/pyprland.toml".text = /*toml*/ ''
      [pyprland]
      plugins = [
        "layout_center",
      ]

      [layout_center]
      offset = [ 0, 14 ] # TODO: 34 should be the same as waybar's height
      margin = [ 800, 37 ] # TODO: 34/2 + (20 should be the same as `gaps_out`)
    '';

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      # package = inputs.hyprland.packages.${systemSettings.system}.hyprland;

      plugins = [];

      settings = {
        "$mod" = "SUPER";
        "$keysymMod" = "Super_L";
        "$terminal" = sessionVariables.TERMINAL;
        "$fileManager" = sessionVariables.FILEMANAGER;
        "$webBrowser" = sessionVariables.BROWSER;
        "$menu" = if config.modules.rofi.enable then
          "rofi -show drun -show-icons"
        else
          builtins.throw "No menu enabled (rofi)";

        exec-once = [
          (lib.mkIf config.modules.waybar.enable "waybar &")
          "nm-applet &"
          "pypr &"
        ];

        monitor = [
          ", preferred, auto, 1"
        ];

        env = let
          cursorSize = builtins.toString config.stylix.cursor.size;
        in [
          "XCURSOR_SIZE, ${cursorSize}"
          "HYPRCURSOR_SIZE, ${cursorSize}"
        ];

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;

          # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          # "col.inactive_border" = "rgba(595959aa)";

          resize_on_border = true;

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
          # "col.shadow" = "rgba(1a1a1aee)";

          blur = {
            enabled = true;
            size = 4;
            passes = 2;

            vibrancy = 0.4;
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

        cursor = {
          inactive_timeout = 16;
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

        # device = {
        #   name = "epic-mouse-v1";
        #   sensitivity = -0.5;
        # };

        windowrulev2 = "suppressevent maximize, class:.*";

        bind = [
          "$mod, F, exec, $webBrowser"
          "$mod, return, exec, $terminal"
          "$mod, C, killactive"
          "$mod, Q, exit"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating"
          "$mod, R, exec, $menu"
          # "$mod, P, pseudo"
          "$mod, J, togglesplit"
          "$mod, O, fullscreen, 0" # fullscreen
          "$mod, U, fullscreen, 1" # maximize
          "$mod, I, togglefloating"

          "$mod, M, exec, pypr layout_center toggle"

          ", Print, exec, hyprshot -m output"

          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, L, movewindow, r"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, J, movewindow, d"

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
              builtins.concatLists (builtins.genList (idx: bindWorkspace (idx + 1)) 10)
          );

        binde = [
          # sound controls
          ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
          ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
          ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"

          # brightness controls (backlight)
          ", XF86MonBrightnessUP, exec, brightnessctl set +10%"
          ", XF86MonBrightnessDOWN, exec, brightnessctl set 10%-"
        ];
      };

      extraConfig = ''
      # resize submap
      bind = $mod, S, submap, resize
      submap = resize
      binde = , H, resizeactive, -24 0
      binde = , L, resizeactive, 24 0
      binde = , K, resizeactive, 0 -24
      binde = , J, resizeactive, 0 24
      bind = , escape, submap, reset
      bind = , catchall, submap, reset
      submap = reset
      '';
    };
  };
}

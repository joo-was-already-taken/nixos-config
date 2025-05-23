{ pkgs, lib, myLib, inputs, config, systemSettings, sessionVariables, ... }:
let
  moduleName = "hyprland";
  defaultColors = with config.lib.stylix.colors; {
    activeBorder1 = base0D;
    activeBorder2 = base0C;
    inactiveBorder = base04;
  };

  floatingWindowSize = "1300 800";
  changeKbLayout = pkgs.writeShellApplication {
    name = "change-kb-layout";
    runtimeInputs = with pkgs; [
      libnotify
    ];
    text = ''
      for kb in $(hyprctl devices | awk '/Keyboard at/ {getline; print $1}'); do
        hyprctl switchxkblayout "$kb" next
      done
      value="$(hyprctl devices | grep -i at-translated-set-2-keyboard -A 2 | tail -n1 | cut -f3-5 -d' ')"
      notify-send "Keyboard layout: $value"
    '';
  };
  toggleMainDisplay = pkgs.writeShellApplication {
    name = "toggle-main-display";
    runtimeInputs = with pkgs; [
      # hyprland
      wlr-randr
    ];
    text = ''
      display="$(wlr-randr | head -n1 | awk '{print $1}')"
      hyprctl dispatch dpms toggle "$display"
    '';
  };
  toggleFloating = pkgs.writeShellApplication {
    name = "hypr-toggle-floating";
    text = ''
      hyprctl dispatch togglefloating
      floating=$(hyprctl activewindow | awk '/floating:/ {print $2}')
      if [ "$floating" == "1" ]; then
        hyprctl dispatch resizeactive exact ${floatingWindowSize}
        hyprctl dispatch centerwindow 1
      fi
    '';
  };
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption moduleName;
    colors = myLib.mkColorsOption defaultColors;
    invisibleInactiveBorder = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = with pkgs; [
      # inputs.pyprland.packages.${systemSettings.system}.pyprland
      wl-clipboard
      pulsemixer
      wlr-randr
      hyprshot
      brightnessctl
      networkmanagerapplet
      libnotify
      swayidle
      wlr-layout-ui
    ];

    # xdg.portal = {
    #   enable = true;
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-hyprland
    #     xdg-desktop-portal-gtk
    #     # xdg-desktop-portal-kde # waybar doesn't work with this enabled
    #   ];
    #   config.common.default = "*";
    # };

    services.mako = {
      enable = true;
      settings.default-timeout = 4000;
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

    # home.file.".config/hypr/pyprland.toml".text = /*toml*/ ''
    #   [pyprland]
    #   plugins = [
    #     "shift_monitors"
    #   ]
    #   # plugins = [
    #   #   "workspaces_follow_focus"
    #   # ]
    #   #
    #   # [workspaces_follow_focus]
    #   # max_workspaces = 0
    # '';

    home.sessionVariables = {
      HYPRSHOT_DIR = config.home.homeDirectory + "/Pictures/Screenshots";
    };

    stylix.targets.hyprland.enable = false;

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      package = null;
      portalPackage = null;
      # plugins = [
      #   inputs.hyprland-plugins.packages.${systemSettings.system}.hyprexpo
      # ];

      settings = let
        numWorkspaces = 10;
      in {
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
          (lib.mkIf config.modules.waybar.enable "waybar")
          (lib.mkIf config.modules.ironbar.enable "ironbar")
          "nm-applet &"
          "(sleep 1; blueman-tray) &"
          (lib.mkIf config.modules.alacritty.enable "alacritty -e zsh -c 'neofetch; zsh' &")
          # "pypr &"
          # "swayidle -w timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'"
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

          "col.active_border" = "rgb(${config.modules.${moduleName}.colors.activeBorder1})"
            + " rgb(${config.modules.${moduleName}.colors.activeBorder2})"
            + " 45deg";
          "col.inactive_border" = "rgba(${config.modules.${moduleName}.colors.inactiveBorder}${
            if config.modules.${moduleName}.invisibleInactiveBorder then "00" else "ff"
          })";

          resize_on_border = true;

          allow_tearing = false;

          layout = "master";
        };

        decoration = {
          rounding = 0;
          active_opacity = 1.0;
          inactive_opacity = 1.0;

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

          focus_on_activate = true;

          initial_workspace_tracking = 1;
        };

        workspace = [
          "w[tv1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ]/* ++ (
          let genWorkspace = ws: "${toString (ws + 1)}, persistent:true";
          in builtins.genList genWorkspace numWorkspaces
        )*/;

        windowrulev2 = [
          # "float, class:.*"
          # "size ${floatingWindowSize}, class:.*"

          # "float, title:Alacritty"
          # "size ${floatingWindowSize}, title:Alacritty*"
          "float, class:nemo"
          "size ${floatingWindowSize}, class:nemo*"
          "float, class:pavucontrol"
          "size ${floatingWindowSize}, class:pavucontrol*"
          "float, class:blueman, title:Bluetooth Devices"
          "size ${floatingWindowSize}, title:Bluetooth Devices*"
          "float, class:.*, title:WLR Layout"
          "size ${floatingWindowSize}, title:WLR Layout*"
          "center, class:.*, title:WLR Layout"

          # "suppressevent maximize, class:.*"
          "bordersize 0, floating:0, onworkspace:w[tv1]"
          "rounding 0, floating:0, onworkspace:w[tv1]"
          "bordersize 0, floating:0, onworkspace:f[1]"
          "rounding 0, floating:0, onworkspace:f[1]"
        ];


        cursor = {
          inactive_timeout = 16;
        };

        input = {
          kb_layout = "pl,de";
          kb_variant = ",us"; # use sane german
          # kb_options = "grp:win_space_toggle"; # already have a script for that

          follow_mouse = 1;
          mouse_refocus = 0;

          sensitivity = 0;

          touchpad = {
            natural_scroll = true;
          };
        };

        gestures = {
          workspace_swipe = false;
        };

        # device = {
        #   name = "epic-mouse-v1";
        #   sensitivity = -0.5;
        # };

        bind = [
          "$mod, F, exec, $webBrowser"
          "$mod, return, exec, $terminal"
          "$mod, C, killactive"
          "$mod, Q, exit"
          "$mod, E, exec, $fileManager"
          "$mod, D, exec, $menu"
          # "$mod, P, pseudo"
          "$mod, J, togglesplit"
          "$mod, O, fullscreen, 0" # fullscreen
          "$mod, U, fullscreen, 1" # maximize
          "$mod, I, exec, ${lib.getExe toggleFloating}"
          "$mod, Y, fullscreenstate, 0 3"

          # "$mod, M, exec, pypr shift_monitors +1"
          "$mod, backslash, exec, ${lib.getExe toggleMainDisplay}"

          # change keyboard layout
          "$mod, space, exec, ${lib.getExe changeKbLayout}"

          # Take a screenshot of an entire monitor
          ", Print, exec, hyprshot -m output"
          # Take a screenshot of selected region
          "Control_L&Control_R, Print, exec, hyprshot -m region"

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
          "$mod SHIFT, N, movetoworkspace, +1"
          "$mod SHIFT, P, movetoworkspace, -1"
        ] ++ ( # generate workspace bindings for workspaces 1 - 9
            let
              bindWorkspace = ws: let
                idx = ws - 1;
              in [
                "$mod, code:1${toString idx}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString idx}, movetoworkspace, ${toString ws}"
              ];
            in
              builtins.concatLists (builtins.genList (idx: bindWorkspace (idx + 1)) numWorkspaces)
          );

        binde = [
          # sound controls
          ", XF86AudioRaiseVolume, exec, pulsemixer --change-volume +5 --max-volume 155"
          ", XF86AudioLowerVolume, exec, pulsemixer --change-volume -5"
          ", XF86AudioMute, exec, pulsemixer --toggle-mute"

          # brightness controls (backlight)
          ", XF86MonBrightnessUP, exec, brightnessctl set +10%"
          ", XF86MonBrightnessDOWN, exec, brightnessctl set 10%-"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
        ];
      };

      extraConfig = ''
        # resize submap
        bind = $mod, S, submap, resize
        submap = resize
        binde = , H, resizeactive, -80 0
        binde = , L, resizeactive, 80 0
        binde = , K, resizeactive, 0 -80
        binde = , J, resizeactive, 0 80
        bind = , escape, submap, reset
        bind = Control_L, bracketleft, submap, reset
        bind = , catchall, submap, reset
        submap = reset

        # group submap
        bind = $mod, G, submap, group
        submap = group
        bind = , G, exec, hyprctl dispatch submap reset; hyprctl dispatch togglegroup
        bind = , H, exec, hyprctl dispatch submap reset; hyprctl dispatch moveintogroup l
        bind = , L, exec, hyprctl dispatch submap reset; hyprctl dispatch moveintogroup r
        bind = , K, exec, hyprctl dispatch submap reset; hyprctl dispatch moveintogroup u
        bind = , J, exec, hyprctl dispatch submap reset; hyprctl dispatch moveintogroup d
        bind = , O, exec, hyprctl dispatch submap reset; hyprctl dispatch moveoutofgroup
        bind = , N, exec, hyprctl dispatch submap reset; hyprctl dispatch movegroupwindow n
        bind = , P, exec, hyprctl dispatch submap reset; hyprctl dispatch movegroupwindow b
        bind = , escape, submap, reset
        bind = Control_L, bracketleft, submap, reset
        bind = , catchall, submap, reset
        submap = group
      '';
    };
  };
}

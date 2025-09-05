{ pkgs, lib, myLib, config, sessionVariables, ... }:
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
      wl-color-picker
    ];

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

    stylix.targets.hyprland.enable = false;

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
      package = null;
      portalPackage = null;
      # plugins = [
      #   inputs.hyprland-plugins.packages.${systemSettings.system}.hyprexpo
      # ];

      extraConfig = ''
        debug:disable_logs = false

        $mod = SUPER
        $keysymMod = Super_L
        $terminal = ${sessionVariables.TERMINAL}
        $fileManager = ${sessionVariables.FILEMANAGER}
        $webBrowser = ${sessionVariables.BROWSER}
        ${
          if config.modules.rofi.enable then
            ''
              $menu = rofi -show drun -show-icons
              $commandMenu = rofi -show run
            ''
          else
            builtins.throw "No menu enabled (rofi)"
        }

        ${if config.modules.waybar.enable then "exec-once = waybar" else ""}
        ${if config.modules.ironbar.enable then "exec-once = ironbar" else ""}
        exec-once = nm-applet &
        exec-once = (sleep 1; blueman-tray) &
        exec-once = ${sessionVariables.TERMINAL} -e zsh -c 'neofetch; zsh' &
        exec-once = pypr &
        # exec-once = swayidle -w timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'

        monitor = , preferred, auto, 1

        env = XCURSOR_SIZE, ${builtins.toString config.stylix.cursor.size}
        env = HYPRCURSOR_SIZE, ${builtins.toString config.stylix.cursor.size}

        env = HYPRSHOT_DIR, ${config.home.homeDirectory}/Pictures/screenshots

        general {
          gaps_in = 5
          gaps_out = 20
          border_size = 2

          col.active_border = ${
            "rgb(${config.modules.${moduleName}.colors.activeBorder1})"
              + " rgb(${config.modules.${moduleName}.colors.activeBorder2})"
              + " 45deg"
          }
          col.inactive_border = ${
            "rgba(${config.modules.${moduleName}.colors.inactiveBorder}${
              if config.modules.${moduleName}.invisibleInactiveBorder then "00" else "ff"
            })"
          }

          resize_on_border = true

          allow_tearing = false

          layout = "master"
        }

        decoration {
          rounding = 0
          active_opacity = 1.0
          inactive_opacity = 1.0

          blur {
            enabled = true
            size = 4
            passes = 2

            vibrancy = 0.4
          }
        }

        animations {
          enabled = true

          bezier = easeOutQuint, 0.23, 1, 0.32, 1
          bezier = easeInOutCubic, 0.65, 0.05, 0.36, 1
          bezier = linear, 0, 0, 1, 1
          bezier = almostLinear, 0.5, 0.5, 0.75, 1.0
          bezier = quick, 0.15, 0, 0.1, 1

          animation = global, 1, 10, default
          animation = border, 1, 5.39, easeOutQuint
          animation = windows, 1, 4.79, easeOutQuint
          animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
          animation = windowsOut, 1, 1.49, linear, popin 87%
          animation = fadeIn, 1, 1.73, almostLinear
          animation = fadeOut, 1, 1.46, almostLinear
          animation = fade, 1, 3.03, quick
          animation = layers, 1, 3.81, easeOutQuint
          animation = layersIn, 1, 4, easeOutQuint, fade
          animation = layersOut, 1, 1.5, linear, fade
          animation = fadeLayersIn, 1, 1.79, almostLinear
          animation = fadeLayersOut, 1, 1.39, almostLinear
          animation = workspaces, 1, 1.4, easeInOutCubic
          # animation = workspacesIn, 1, 1.21, almostLinear, fade
          # animation = workspacesOut, 1, 1.94, almostLinear, fade
        }

        dwindle {
          pseudotile = true
          preserve_split = true
        }

        master {
          new_status = master
        }

        misc {
          force_default_wallpaper = -1
          disable_hyprland_logo = true
          disable_splash_rendering = true

          focus_on_activate = true

          initial_workspace_tracking = 1

          vfr = true
        }

        workspace = w[tv1], gapsout:0, gapsin:0
        workspace = f[1], gapsout:0, gapsin:0

        windowrulev2 = float, class:nemo
        windowrulev2 = size ${floatingWindowSize}, class:nemo*
        windowrulev2 = float, class:pavucontrol
        windowrulev2 = size ${floatingWindowSize}, class:pavucontrol*
        windowrulev2 = float, class:blueman, title:Bluetooth Devices
        windowrulev2 = size ${floatingWindowSize}, title:Bluetooth Devices*
        windowrulev2 = float, class:.*, title:WLR Layout
        windowrulev2 = size ${floatingWindowSize}, title:WLR Layout*
        windowrulev2 = center, class:.*, title:WLR Layout

        windowrulev2 = bordersize 0, floating:0, onworkspace:w[tv1]
        windowrulev2 = rounding 0, floating:0, onworkspace:w[tv1]
        windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
        windowrulev2 = rounding 0, floating:0, onworkspace:f[1]


        cursor {
          inactive_timeout = 16
        }

        input {
          kb_layout = pl, de
          kb_variant = , us # use sane german
          # kb_options = grp:win_space_toggle # already have a script for that

          follow_mouse = 1
          mouse_refocus = 0

          sensitivity = 0

          touchpad {
            natural_scroll = true
          }
        }

        gestures {
          workspace_swipe = false
        }

        bind = $mod, F, exec, $webBrowser
        bind = $mod, return, exec, $terminal
        bind = $mod, C, killactive
        bind = $mod, Q, exit
        bind = $mod, E, exec, $fileManager
        bind = $mod, D, exec, $menu
        bind = $mod, R, exec, $commandMenu
        # bind = $mod, P, pseudo
        bind = $mod, J, togglesplit
        bind = $mod, O, fullscreen, 0 # fullscreen
        bind = $mod, U, fullscreen, 1 # maximize
        bind = $mod, I, exec, ${lib.getExe toggleFloating}
        bind = $mod, Y, fullscreenstate, 0 3

        # bind = $mod, M, exec, pypr shift_monitors +1
        bind = $mod, backslash, exec, ${lib.getExe toggleMainDisplay}

        # change keyboard layout
        bind = $mod, space, exec, ${lib.getExe changeKbLayout}

        # Take a screenshot of an entire monitor
        bind = , Print, exec, hyprshot -m output
        # Take a screenshot of selected region
        bind = Control_L&Control_R, Print, exec, hyprshot -m region

        # Color picker
        bind = $mod, minus, exec, wl-color-picker

        bind = $mod, H, movefocus, l
        bind = $mod, L, movefocus, r
        bind = $mod, K, movefocus, u
        bind = $mod, J, movefocus, d
        bind = $mod, semicolon, cyclenext
        bind = $mod, semicolon, alterzorder, top

        bind = $mod SHIFT, H, movewindow, l
        bind = $mod SHIFT, L, movewindow, r
        bind = $mod SHIFT, K, movewindow, u
        bind = $mod SHIFT, J, movewindow, d

        bind = $mod, N, workspace, +1
        bind = $mod, P, workspace, -1
        bind = $mod SHIFT, N, movetoworkspace, +1
        bind = $mod SHIFT, P, movetoworkspace, -1
        ${ # generate workspace bindings for workspaces 1 - 10
          let
            bindWorkspace = ws: let
              idx = ws - 1;
            in [
              "bind = $mod, code:1${toString idx}, workspace, ${toString ws}"
              "bind = $mod SHIFT, code:1${toString idx}, movetoworkspace, ${toString ws}"
            ];
            workspacesBinds = builtins.genList (idx: bindWorkspace (idx + 1)) 10;
          in
            builtins.concatStringsSep "\n" (builtins.concatLists workspacesBinds)
        }

        # sound controls
        binde = , XF86AudioRaiseVolume, exec, pulsemixer --change-volume +5 --max-volume 155
        binde = , XF86AudioLowerVolume, exec, pulsemixer --change-volume -5
        binde = , XF86AudioMute, exec, pulsemixer --toggle-mute

        # brightness controls (backlight)
        binde = , XF86MonBrightnessUP, exec, brightnessctl set +10%
        binde = , XF86MonBrightnessDOWN, exec, brightnessctl set 10%-

        bindm = $mod, mouse:272, movewindow


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
        submap = reset
      '';
    };
  };
}
